import argparse
import csv
import io
import re
import sys
from datetime import date, datetime

DATE_RE = re.compile(r"^(\d{4})[-/](\d{2})[-/](\d{2})")


def parse_row(row):
    record_date = datetime.strptime(row["Date"], "%Y-%m-%d").date()
    start = datetime.strptime(row["Date/time"], "%Y-%m-%d %H:%M:%S")
    end = datetime.strptime(row["End date/time"], "%Y-%m-%d %H:%M:%S")
    lines = [line.strip() for line in row["Description"].splitlines()]
    bullets = [line[1:].strip() for line in lines if line.startswith("-")]
    heading = next((line.lstrip("#").strip() for line in lines if line.startswith("#")), "")
    summary = row.get("Tags", "").strip() or heading
    return record_date, start, end, summary, bullets


def klog_time(moment, record_date):
    shift = (moment.date() - record_date).days
    clock = f"{moment.hour}:{moment.minute:02d}"
    if shift == 0:
        return clock
    if shift == 1:
        return f"{clock}>"
    if shift == -1:
        return f"<{clock}"
    raise ValueError(f"{moment} is {shift} days from record date {record_date}")


def tag_suffix(row, project, client):
    project = project if project is not None else row.get("Project", "")
    client = client if client is not None else row.get("Company", "")
    tags = []
    if project:
        tags.append(f'#project="{project}"')
    if client:
        tags.append(f'#client="{client}"')
    return " ".join(tags)


def render(rows, project=None, client=None, exclude=frozenset()):
    by_date = {}
    for row in rows:
        record_date, start, end, summary, bullets = parse_row(row)
        entry = (start, end, summary, bullets, tag_suffix(row, project, client))
        by_date.setdefault(record_date, []).append(entry)

    records, skipped = [], []
    for record_date in sorted(by_date):
        if record_date in exclude:
            skipped.append(record_date)
            continue
        lines = [record_date.isoformat()]
        for start, end, summary, bullets, tags in sorted(by_date[record_date]):
            head = " ".join(part for part in (summary, tags) if part)
            lines.append(
                f"    {klog_time(start, record_date)} - {klog_time(end, record_date)} {head}".rstrip()
            )
            lines.extend(f"        - {bullet}" for bullet in bullets)
        records.append("\n".join(lines))
    return "\n\n".join(records), skipped


def existing_dates(text):
    found = set()
    for line in text.splitlines():
        match = DATE_RE.match(line)
        if match:
            year, month, day = (int(part) for part in match.groups())
            found.add(date(year, month, day))
    return frozenset(found)


def append_prefix(text):
    if not text or text.endswith("\n\n"):
        return ""
    return "\n" if text.endswith("\n") else "\n\n"


def total_minutes(rows):
    return sum(
        int((parse_row(row)[2] - parse_row(row)[1]).total_seconds() // 60) for row in rows
    )


SELFTEST_CSV = '''"ID","Date","Date/time","End date/time","Project","Who","Description","Project category","Company","Is it billable?","Hours","Minutes","Decimal hours","Tags","Task tags","First name","Last name","User ID"
"b","2026-07-17","2026-07-17 14:10:00","2026-07-17 19:30:00","Acme","D P","## widget
- did a thing (abc123)
- did ""another"" thing","","","No","5","20","5.33","widget","","D","P","u1"
"a","2026-07-17","2026-07-17 09:01:00","2026-07-17 13:23:00","Acme","D P","## widget
- morning work","","","No","4","22","4.37","widget","","D","P","u1"
"c","2026-07-18","2026-07-18 22:00:00","2026-07-19 01:30:00","Acme","D P","## widget
- late night","","","No","3","30","3.50","widget","","D","P","u1"
'''


def selftest():
    rows = list(csv.DictReader(io.StringIO(SELFTEST_CSV)))
    out, skipped = render(rows, project="Acme Projects", client="Acme")
    expected = '\n'.join([
        '2026-07-17',
        '    9:01 - 13:23 widget #project="Acme Projects" #client="Acme"',
        '        - morning work',
        '    14:10 - 19:30 widget #project="Acme Projects" #client="Acme"',
        '        - did a thing (abc123)',
        '        - did "another" thing',
        '',
        '2026-07-18',
        '    22:00 - 1:30> widget #project="Acme Projects" #client="Acme"',
        '        - late night',
    ])
    assert out == expected, f"got:\n{out}\n\nwant:\n{expected}"
    assert skipped == []
    assert total_minutes(rows) == 4 * 60 + 22 + 5 * 60 + 20 + 3 * 60 + 30

    _, skipped = render(rows, exclude=existing_dates("2026-07-17\n    1h x\n"))
    assert skipped == [date(2026, 7, 17)], skipped

    out, _ = render(rows[:1])
    assert '#project="Acme"' in out and "#client" not in out, out

    assert append_prefix("") == ""
    assert append_prefix("2026-07-17\n    1h x\n\n") == ""
    assert append_prefix("2026-07-17\n    1h x\n") == "\n"
    assert append_prefix("2026-07-17\n    1h x") == "\n\n"
    print("selftest ok", file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description="Convert a Teamwork time CSV export to klog records.")
    parser.add_argument("csv", nargs="?", help="CSV file, or - for stdin")
    parser.add_argument("--project", help="value for #project (default: CSV Project column)")
    parser.add_argument("--client", help="value for #client (default: CSV Company column)")
    parser.add_argument("--exclude-from", metavar="KLG", help="skip dates already present in this .klg file")
    parser.add_argument("--append", metavar="KLG", help="append to this .klg file instead of stdout, skipping dates it already has")
    parser.add_argument("--selftest", action="store_true")
    args = parser.parse_args()

    if args.selftest:
        return selftest()
    if not args.csv:
        parser.error("csv is required")

    source = sys.stdin if args.csv == "-" else open(args.csv, newline="", encoding="utf-8")
    with source as handle:
        rows = list(csv.DictReader(handle))

    target = args.append or args.exclude_from
    existing = ""
    if target:
        with open(target, encoding="utf-8") as handle:
            existing = handle.read()

    out, skipped = render(rows, args.project, args.client, existing_dates(existing))

    if args.append:
        if out:
            with open(args.append, "a", encoding="utf-8") as handle:
                handle.write(append_prefix(existing) + out + "\n")
    elif out:
        print(out)

    minutes = total_minutes(rows)
    print(f"{len(rows)} entries, {minutes // 60}h{minutes % 60:02d}m in CSV", file=sys.stderr)
    for record_date in skipped:
        print(f"skipped {record_date}: already in {target}", file=sys.stderr)
    if args.append:
        added = len(out.split("\n\n")) if out else 0
        print(f"appended {added} records to {args.append}", file=sys.stderr)


if __name__ == "__main__":
    main()
