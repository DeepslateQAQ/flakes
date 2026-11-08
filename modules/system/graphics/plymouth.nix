{ pkgs, ... }:

let
  themeName = "deepslate-bgrt";
  spinnerSize = 96;
  spinnerImageSize = 68;
  avatar = ../../../assets/deepslate/avatar_2d_raw.png;

  deepslateBgrtTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "deepslate-plymouth-bgrt";
    version = "1.0.0";

    dontUnpack = true;
    nativeBuildInputs = [ pkgs.imagemagick ];

    installPhase = ''
            runHook preInstall

            themeDir="$out/share/plymouth/themes/${themeName}"
            mkdir -p "$themeDir"

            cp -a ${pkgs.plymouth}/share/plymouth/themes/spinner/. "$themeDir/"
            chmod -R u+w "$themeDir"
            rm -f "$themeDir"/animation-*.png "$themeDir"/throbber-*.png "$themeDir"/spinner.plymouth

            src="${avatar}"
            read width height < <(magick identify -format '%w %h\n' "$src")
            bbox="$(magick "$src" -alpha extract -threshold 0 -format '%@' info:)"
            read bboxWidth bboxHeight bboxX bboxY < <(
              printf '%s\n' "$bbox" | sed -E 's/^([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+)$/\1 \2 \3 \4/'
            )

            baseSide="$width"
            if [ "$height" -lt "$baseSide" ]; then
              baseSide="$height"
            fi

            baseX=$(( (width - baseSide) / 2 ))
            baseY=$(( (height - baseSide) / 2 ))
            leftMargin=$(( bboxX - baseX ))
            rightMargin=$(( baseX + baseSide - bboxX - bboxWidth ))
            topMargin=$(( bboxY - baseY ))
            bottomMargin=$(( baseY + baseSide - bboxY - bboxHeight ))

            inset="$leftMargin"
            for margin in "$rightMargin" "$topMargin" "$bottomMargin"; do
              if [ "$margin" -lt "$inset" ]; then
                inset="$margin"
              fi
            done
            if [ "$inset" -lt 0 ]; then
              inset=0
            fi

            cropSide=$(( baseSide - 2 * inset ))
            baseFrame="$TMPDIR/deepslate-spinner-base.png"
            magick "$src" \
              -gravity center \
              -crop "$cropSide"x"$cropSide"+0+0 +repage \
              -resize ${toString spinnerImageSize}x${toString spinnerImageSize} \
              -background none \
              -gravity center \
              -extent ${toString spinnerSize}x${toString spinnerSize} \
              "$baseFrame"

            makeFrames() {
              prefix="$1"
              count="$2"
              i=1

              while [ "$i" -le "$count" ]; do
                frame="$(printf '%04d' "$i")"
                angle=$(( (i - 1) * 360 / count ))

                magick "$baseFrame" \
                  -background none \
                  -virtual-pixel transparent \
                  -distort SRT "$angle" \
                  "$themeDir/$prefix-$frame.png"

                i=$(( i + 1 ))
              done
            }

            makeFrames animation 36
            makeFrames throbber 30

            cat > "$themeDir/${themeName}.plymouth" <<EOF
      [Plymouth Theme]
      Name=深板岩 BGRT
      Description=使用旋转深板岩头像作为加载动画的 BGRT 主题。
      ModuleName=two-step

      [two-step]
      Font=Noto Sans CJK SC 12
      TitleFont=Noto Sans CJK SC Light 30
      ImageDir=$themeDir
      DialogHorizontalAlignment=.5
      DialogVerticalAlignment=.382
      TitleHorizontalAlignment=.5
      TitleVerticalAlignment=.382
      HorizontalAlignment=.5
      VerticalAlignment=.7
      WatermarkHorizontalAlignment=.5
      WatermarkVerticalAlignment=.96
      Transition=none
      TransitionDuration=0.0
      BackgroundStartColor=0x000000
      BackgroundEndColor=0x000000
      ProgressBarBackgroundColor=0x606060
      ProgressBarForegroundColor=0xffffff
      DialogClearsFirmwareBackground=true
      MessageBelowAnimation=true

      [boot-up]
      UseEndAnimation=false
      UseFirmwareBackground=true

      [shutdown]
      UseEndAnimation=false
      UseFirmwareBackground=true

      [reboot]
      UseEndAnimation=false
      UseFirmwareBackground=true

      [updates]
      SuppressMessages=true
      ProgressBarShowPercentComplete=true
      UseProgressBar=true
      Title=正在安装更新...
      SubTitle=请勿关闭计算机

      [system-upgrade]
      SuppressMessages=true
      ProgressBarShowPercentComplete=true
      UseProgressBar=true
      Title=正在升级系统...
      SubTitle=请勿关闭计算机

      [firmware-upgrade]
      SuppressMessages=true
      ProgressBarShowPercentComplete=true
      UseProgressBar=true
      Title=正在升级固件...
      SubTitle=请勿关闭计算机

      [system-reset]
      SuppressMessages=true
      ProgressBarShowPercentComplete=true
      UseProgressBar=true
      Title=正在重置系统...
      SubTitle=请勿关闭计算机
      EOF

            runHook postInstall
    '';
  };
in
{
  boot.plymouth = {
    enable = true;
    font = "${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk/NotoSansCJK-VF.otf.ttc";
    theme = themeName;
    themePackages = [ deepslateBgrtTheme ];
  };

  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "rd.systemd.show_status=false"
    "rd.udev.loglevel=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"
    "fbcon=nodefer"
  ];
  boot.consoleLogLevel = 3;
  # boot.initrd.verbose = false;

  boot.loader.timeout = 0;
  boot.loader.systemd-boot.consoleMode = "keep";
}
