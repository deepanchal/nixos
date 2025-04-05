{
  config,
  inputs,
  pkgs,
  ...
}: let
  search = {
    default = "ddg";
    force = true;
    engines = {
      # don't need these default ones
      "amazondotcom-us".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "ddg" = {
        urls = [
          {
            template = "https://duckduckgo.com";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",d"];
      };
      "google" = {
        urls = [
          {
            template = "https://google.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",g"];
      };
      "nix-pkgs" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",ns"];
      };
      "youtube" = {
        urls = [
          {
            template = "https://www.youtube.com/results";
            params = [
              {
                name = "search_query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",yt"];
      };
      "wikipedia" = {
        urls = [
          {
            template = "https://en.wikipedia.org/wiki/Special:Search";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",w"];
      };
      "dockerhub" = {
        urls = [
          {
            template = "https://hub.docker.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",dh"];
      };
      "gitHub" = {
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        definedAliases = [",gh"];
      };
    };
  };
  settings = {
    "dom.security.https_only_mode" = true; # force https
    "browser.download.panel.shown" = true; # show download panel
    "identity.fxaccounts.enabled" = false; # disable firefox accounts
    "signon.rememberSignons" = false; # disable saving passwords
    "extensions.pocket.enabled" = false; # disable pocket
    "app.shield.optoutstudies.enabled" = false; # disable shield studies
    "app.update.auto" = false; # disable auto update
    "browser.bookmarks.restore_default_bookmarks" = false; # don't restore default bookmarks
    "browser.quitShortcut.disabled" = true; # disable ctrl+q
    "browser.shell.checkDefaultBrowser" = false; # don't check if default browser
    "browser.startup.page" = 3; # restore previous session

    # ui changes
    "browser.fullscreen.autohide" = false; # dont hide tabs in fullscreen mode
    "browser.aboutConfig.showWarning" = false; # disable warning about about:config
    "browser.compactmode.show" = false;
    "browser.uidensity" = 0;
    "general.autoScroll" = true; # enable autoscroll
    "general.smoothScroll" = true;
    "browser.tabs.firefox-view" = false; # enable firefox view
    "browser.toolbars.bookmarks.visibility" = "never"; # hide bookmarks toolbar
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false; # disable picture in picture button
    "startup.homepage_welcome_url" = ""; # disable welcome page
    "browser.newtabpage.enabled" = false; # disable new tab page
    # "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # enable userChrome.css
    "full-screen-api.ignore-widgets" = true; # fullscreen within window

    # privacy
    "browser.contentblocking.category" = "custom"; # set tracking protection to custom
    "browser.discovery.enabled" = false; # disable discovery
    "browser.search.suggest.enabled" = false; # disable search suggestions
    "browser.protections_panel.infoMessage.seen" = true; # disable tracking protection info

    # let me close and open tabs without confirmation
    "browser.tabs.closeWindowWithLastTab" = true; # don't close window when last tab is closed
    "browser.tabs.loadBookmarksInTabs" = true; # open bookmarks in new tab
    "browser.tabs.loadDivertedInBackground" = false; # open new tab in background
    "browser.tabs.loadInBackground" = true; # open new tab in background
    "browser.tabs.warnOnClose" = false; # don't warn when closing multiple tabs
    "browser.tabs.warnOnCloseOtherTabs" = false; # don't warn when closing multiple tabs
    "browser.tabs.warnOnOpen" = false; # don't warn when opening multiple tabs
    "browser.tabs.warnOnQuit" = false; # don't warn when closing multiple tabs

    # nvidia / video acceleration
    # See: https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
    "media.ffmpeg.vaapi.enabled" = true; # enable hardware acceleration
    "media.rdd-ffmpeg.enabled" = true;
    # "media.av1.enabled" = false;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;

    # other
    "devtools.cache.disabled" = true; # disable caching in devtools
    "devtools.toolbox.host" = "right"; # move devtools to right
    # "browser.ssb.enabled" = true; # enable site specific browser
    "media.autoplay.default" = 0; # enable autoplay on open
    # "media.ffmpeg.vaapi.enabled" = true; # enable hardware acceleration
    # "media.rdd-vpx.enabled" = true; # enable hardware acceleration

    # # override fonts (Set tracking protection to custom without "Suspected fingerprinters")
    # "font.minimum-size.x-western" = 13;
    # "font.size.fixed.x-western" = 15;
    # "font.size.monospace.x-western" = 15;
    # "font.size.variable.x-western" = 15;
    # "font.name.monospace.x-western" = "${defaultFont}";
    # "font.name.sans-serif.x-western" = "${defaultFont}";
    # "font.name.serif.x-western" = "${defaultFont}";
    # "browser.display.use_document_fonts" = 0;
  };
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    darkreader
    ublock-origin
    bitwarden
    multi-account-containers
    temporary-containers
    canvasblocker
    # noscript
    # privacy-badger
    # clearurls
    # decentraleyes
    vimium
    # refined-github
    # github-file-icons
    switchyomega
    # vue-js-devtools
  ];
in {
  programs.firefox = {
    enable = true;
    profiles = {
      personal = {
        id = 0;
        isDefault = true;
        bookmarks = {
          force = true;
          settings = [];
        };
        extensions.packages = extensions;
        containers = {};
        search = search;
        settings = settings;
      };
      work = {
        id = 1;
        bookmarks = {
          force = true;
          settings = [];
        };
        extensions.packages = extensions;
        containers = {};
        search = search;
        settings = settings;
      };
    };
  };
}
