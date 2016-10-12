/**
 * Created by gamersky on 15/10/20.
 */
var kGSAppVideo_FirstVideoBuffer = null;
function gsAppVideoGetFirstVideo()
{
    if (kGSAppVideo_FirstVideoBuffer!=null)
    {
        return kGSAppVideo_FirstVideoBuffer;
    }

    var firstVideo = null;
    var videos = document.getElementsByTagName("video");
    if (videos!=null && videos.length>0)
    {
        var videosCount = videos.length;
        for (var videoIndex=0; videoIndex<videosCount; videoIndex++)
        {
            firstVideo = videos[videoIndex];
            if (firstVideo!=null)
            {
                break;
            }
        }
    }
    kGSAppVideo_FirstVideoBuffer = firstVideo;

    return firstVideo;
}
function gsAppVideoIsValidVideoExisted()
{
    var firstVideo = gsAppVideoGetFirstVideo();
    if (firstVideo==null)
    {
        return "no";
    }
    return "yes";
}
function gsAppVideoGetFirstVideoPosterImgURL()
{
    var firstVideo = gsAppVideoGetFirstVideo();

    if (firstVideo!=null)
    {
        // 乐视
        var firstVideoPoster = firstVideo.poster;
        if (firstVideoPoster!=null
            && firstVideoPoster.length>0)
        {
            return firstVideoPoster;
        }

        // 优酷
        var imgs = document.getElementsByTagName("img");
        if (imgs!=null
            && imgs.length>0)
        {
            var img = imgs[0];
            {
            }
            return img.src;
        }

        // 土豆
        var posters = document.getElementsByClassName("poster");
        if (posters!=null
        && posters.length>0)
        {
            var poster = posters[0];
            {
            }
            return poster.style.backgroundImage;
        }
    }
    return null;
}
function gsAppVideoGetFirstVideoSrc()
{
    var firstVideo = gsAppVideoGetFirstVideo();

    if (firstVideo!=null)
    {
        var videoSrc = firstVideo.src;
        try
        {
            if (videoSrc==null
                || videoSrc.length<1)
            {
                firstVideo.muted = true;

                var playButton = document.getElementById("x-video-button");
                var touchendEvent = document.createEvent('TouchEvent');
                {
                    touchendEvent.initEvent('touchend', true, true);
                }
                playButton.dispatchEvent(touchendEvent);

                setTimeout(function()
                {
                    firstVideo.pause();
                }, 1000);
            }
        }
        catch (e)
        {}
        return videoSrc;
    }

    return null;
}
function gsAppVideoPlayFirstVideo()
{
    var firstVideo = gsAppVideoGetFirstVideo();
    if (firstVideo!=null)
    {
        firstVideo.play();
    }
}
function gsAppVideoPauseFirstVideo()
{
    var firstVideo = gsAppVideoGetFirstVideo();
    if (firstVideo!=null)
    {
        firstVideo.pause();
    }
}
function gsAppVideoIsFirstVideoPlaying()
{
    var firstVideo = gsAppVideoGetFirstVideo();
    if (firstVideo!=null)
    {
        if (!firstVideo.paused())
        {
            return "yes";
        }
    }
    return "no";
}
function getVideoAndImageSrc()
{
    var videoSrc = gsAppVideoGetFirstVideoSrc();
    var imgSrc = gsAppVideoGetFirstVideoPosterImgURL();
    if (videoSrc != null && videoSrc.length > 0 && imgSrc != null && imgSrc.length > 0)
    {
        _video.setVideoAndImage(videoSrc, imgSrc);
        _video.stop();
    }
    else
    {
        setTimeout("getVideoAndImageSrc()", 200);
    }
}