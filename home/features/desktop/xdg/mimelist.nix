let
  # browser = "firefox.desktop";
  browser = "brave-browser.desktop";
  editor = "code.desktop";
  file-manager = "org.gnome.Nautilus.desktop";
  image-viewer = "org.gnome.Loupe.desktop";
  image-editor = "org.kde.kolourpaint";
  audio-player = "mpv.desktop";
  video-player = "mpv.desktop";
in
{
  xdg.mimeApps = rec {
    enable = true;
    associations.added = defaultApplications;
    defaultApplications = {
      "inode/directory" = file-manager;

      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "application/xhtml+xml" = browser;
      "text/html" = browser;

      "application/pdf" = browser;
      "application/json" = browser;
      "application/x-shellscript" = editor;

      # image formats
      "image/jpeg" = image-editor;
      "image/bmp" = image-viewer;
      "image/gif" = image-viewer;
      "image/jpg" = image-viewer;
      "image/pjpeg" = image-viewer;
      "image/png" = image-editor;
      "image/tiff" = image-viewer;
      "image/webp" = image-editor;
      "image/x-bmp" = image-viewer;
      "image/x-gray" = image-viewer;
      "image/x-icb" = image-viewer;
      "image/x-ico" = image-editor;
      "image/x-png" = image-editor;
      "image/x-portable-anymap" = image-viewer;
      "image/x-portable-bitmap" = image-viewer;
      "image/x-portable-graymap" = image-viewer;
      "image/x-portable-pixmap" = image-viewer;
      "image/x-xbitmap" = image-viewer;
      "image/x-xpixmap" = image-viewer;
      "image/x-pcx" = image-viewer;
      "image/svg+xml" = image-viewer;
      "image/svg+xml-compressed" = image-viewer;
      "image/vnd.wap.wbmp" = image-viewer;
      "image/x-icns" = image-viewer;

      # audio formats
      "audio/ogg" = audio-player;
      "audio/mpeg" = audio-player;
      "audio/wav" = audio-player;
      "audio/webm" = audio-player;

      # video formats
      "video/mp4" = video-player;
      "video/webm" = video-player;
      "video/ogg" = video-player;
      "video/mpeg" = video-player;
      "video/x-msvideo" = video-player;

      "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
    };
  };
}
