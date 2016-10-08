////////////////////////////////////////////////
/*基础函数*/
////////////////////////////////////////////////
String.prototype.replaceAll = function(key, value)
{
    var regExp = new RegExp(key, "gm");//g,全局;m,多次;i,大小写不敏感
    return this.replace(regExp, value);
}
String.prototype.indexOfWithIgnorecase = function(key)
{
    var regExp = eval("/"+ key +"/i");
    var result = this.match(regExp);
    if (result!=null)
    {
        return result.index;
    }
    return -1;
}
////////////////////////////////////////////////
/*模板函数*/
////////////////////////////////////////////////
var _kGSOSBuffer = 0;// 0 未知, 1 iOS, 2 Androi
var _kGSAppVersionNumberCode = parseInt(kAppVersion.replaceAll("\\.", ""));
var _kGSIsNightColorModeBuffer = typeof(kDefaultPageColorMode)!="undefined" && kDefaultPageColorMode=="night";
var _kGSIsNullImageModeBuffer = typeof(kDefaultNullImageMode)!="undefined" && kDefaultNullImageMode=="yes";
function gsIsCurrentOSIOS()
{
    if (_kGSOSBuffer==1)
    {
        return true;
    }
    else if (_kGSOSBuffer==0)
    {
        if (typeof(kOS)!="undefined")
        {
            if (kOS=="android")
            {
                _kGSOSBuffer = 2;
            }
            else if (kOS=="ios")
            {
                _kGSOSBuffer = 1;
                return true;
            }
        }
        return false;
    }
    return false;
}
function gsIsCurrentOSAndroid()
{
    if (_kGSOSBuffer==2)
    {
        return true;
    }
    else if (_kGSOSBuffer==0)
    {
        if (typeof(kOS)!="undefined")
        {
            if (kOS=="android")
            {
                _kGSOSBuffer = 2;
                return true;
            }
            else if (kOS=="ios")
            {
                _kGSOSBuffer = 1;
            }
        }
        return false;
    }
    return false;
}
var _kGSIsCurrentAppNullImageProgressVersion = false;
var _kGSIsImageNeedDocumentReadyEventVersion = false;
var _kGSIsGIFImageNeedBadge = false;
var _kGSIsImageCanClickVersion = false;
if (gsIsCurrentOSAndroid())
{
    if (kAppVersion=="1.0.6")
    {
        _kGSIsCurrentAppNullImageProgressVersion = true;
        _kGSIsImageNeedDocumentReadyEventVersion = true;
    }
    else
    {
        _kGSIsImageCanClickVersion = true;
    }
}
else
{
    if (kAppVersion=="1.3.2")
    {
        _kGSIsCurrentAppNullImageProgressVersion = true;
        _kGSIsImageNeedDocumentReadyEventVersion = true;
    }
    else
    {
        _kGSIsImageCanClickVersion = true;
    }
}
if (!_kGSIsCurrentAppNullImageProgressVersion
    && typeof(kNetworkType)!="undefined"
    && kNetworkType=="WWAN")
{
    _kGSIsGIFImageNeedBadge = true;
}
// 返回值为对象{valid:true/false, imgTag:Img标签 imgHDURL:"图片高清地址"}
function gsCheckTheURL(url, superATag)
{
    var result = new Object();
    {
        result.valid = false;
        result.imgTag = null;
        result.imgHDURL = "";
    }

    if (url!=null
        && typeof (url)!="undefined"
        && url.length>0)
    {
        result.valid = true;

        if (superATag != null)
        {
            var aTagChildNodes = superATag.childNodes;
            if (aTagChildNodes != null
                && aTagChildNodes.length == 1)
            {
                var aTagChildNode = aTagChildNodes[0];
                if (aTagChildNode != null
                    && aTagChildNode.tagName != null
                    && aTagChildNode.tagName == "IMG")
                {
                    result.valid = false;
                    result.imgTag = aTagChildNode;
                    var urlExfileName
                        = url.substring(url.length - 4, url.length);
                    if (urlExfileName == ".jpg"
                        || urlExfileName == ".gif"
                        || urlExfileName == "jpeg"
                        || urlExfileName == ".png"
                        || urlExfileName == ".bmp")
                    {
                        var urlSections = url.split("?");
                        if (urlSections != null
                            && urlSections.length > 1)
                        {
                            result.imgHDURL = urlSections[1];
                        }
                    }
                }
            }
        }
    }

    return result;
    /*
     if (url==null || url.length<1)
     {
     return false;
     }

     url = url.toLowerCase();

     var gsURL = function(){};
     gsURL.urlParam = "";
     var urlParamBeginCharIndex = url.indexOf("?");
     if (urlParamBeginCharIndex!=-1)
     {
     urlParamBeginCharIndex += 1;
     gsURL.urlParam = url.substring(urlParamBeginCharIndex, url.length);
     url = url.substring(0, urlParamBeginCharIndex);
     }

     gsURL.urlProtocol = "";
     var urlProtocolEndCharIndex = url.indexOf("://");
     if (urlProtocolEndCharIndex!=-1)
     {
     gsURL.urlProtocol = url.substring(0, urlProtocolEndCharIndex);
     url = url.substring(urlProtocolEndCharIndex+3, url.length);
     }

     gsURL.urlDomain = "";
     var urlDomainEndCharIndex = url.indexOf("/");
     if (urlDomainEndCharIndex!=-1)
     {
     gsURL.urlDomain = url.substring(0, urlDomainEndCharIndex);
     url = url.substring(urlDomainEndCharIndex, url.length);
     }

     gsURL.urlPageFilePath = url;

     gsURL.urlPageFileName = "";
     var urlPageFileNameBeginCharIndex = url.lastIndexOf("/");
     if (urlPageFileNameBeginCharIndex!=-1)
     {
     urlPageFileNameBeginCharIndex += 1;
     gsURL.urlPageFileName = url.substring(urlPageFileNameBeginCharIndex, url.length);
     }

     gsURL.urlPagePureFileName = gsURL.urlPageFileName;
     var urlPagePureFileNameEndCharIndex = gsURL.urlPageFileName.lastIndexOf(".");
     if (urlPagePureFileNameEndCharIndex!=-1)
     {
     gsURL.urlPagePureFileName
     = gsURL.urlPageFileName.substring(0, urlPagePureFileNameEndCharIndex);
     }

     gsURL.urlPageFileExname = "";
     var urlPageFileExnameEndCharIndex = gsURL.urlPageFileName.lastIndexOf(".");
     if (urlPageFileExnameEndCharIndex!=-1)
     {
     urlPageFileExnameEndCharIndex += 1;
     gsURL.urlPageFileExname
     = gsURL.urlPageFileName.substring(urlPageFileExnameEndCharIndex, gsURL.urlPageFileName.length);
     }
     var gamerskyDomain = "gamersky.com";
     var gamerskyDomainIndex = gsURL.urlDomain.indexOf(gamerskyDomain);
     if (gamerskyDomainIndex==-1
     || gamerskyDomainIndex+gamerskyDomain.length!=gsURL.urlDomain.length)
     {
     return false;
     }

     var v_gamerskyDomain = "v.gamersky.com";
     var v_gamerskyDomainIndex = gsURL.urlDomain.indexOf(v_gamerskyDomain);
     if (v_gamerskyDomainIndex!=-1
     && v_gamerskyDomainIndex+v_gamerskyDomain.length==gsURL.urlDomain.length)
     {
     return false;
     }

     var shouyou_gamerskyDomain = "shouyou.gamersky.com";
     var shouyou_gamerskyDomainIndex = gsURL.urlDomain.indexOf(shouyou_gamerskyDomain);
     if (shouyou_gamerskyDomainIndex!=-1
     && shouyou_gamerskyDomainIndex+shouyou_gamerskyDomain.length==gsURL.urlDomain.length)
     {
     if (!gsURL.urlPageFilePath.indexOf("/gl/")==0
     && !gsURL.urlPageFilePath.indexOf("/review/")==0
     && !gsURL.urlPageFilePath.indexOf("/news/")==0)
     {
     return false;
     }
     }

     var down_gamerskyDomain = "down.gamersky.com";
     var down_gamerskyDomainIndex = gsURL.urlDomain.indexOf(down_gamerskyDomain);
     if (down_gamerskyDomainIndex!=-1
     && down_gamerskyDomainIndex+down_gamerskyDomain.length==gsURL.urlDomain.length)
     {
     return false;
     }

     var donghua_gamerskyDomain = "donghua.gamersky.com";
     var donghua_gamerskyDomainIndex = gsURL.urlDomain.indexOf(donghua_gamerskyDomain);
     if (donghua_gamerskyDomainIndex!=-1
     && donghua_gamerskyDomainIndex+donghua_gamerskyDomain.length==gsURL.urlDomain.length)
     {
     return false;
     }

     var pic_gamerskyDomain = "pic.gamersky.com";
     var pic_gamerskyDomainIndex = gsURL.urlDomain.indexOf(pic_gamerskyDomain);
     if (pic_gamerskyDomainIndex!=-1
     && pic_gamerskyDomainIndex+pic_gamerskyDomain.length==gsURL.urlDomain.length)
     {
     return false;
     }

     if (gsURL.urlPageFilePath.indexOf("/pc")==0
     || gsURL.urlPageFilePath.indexOf("/Soft")==0
     || gsURL.urlPageFilePath.indexOf("/soft")==0
     || gsURL.urlPageFilePath.indexOf("/tv")==0)
     {
     return false;
     }

     var validPageExname = ".shtml";
     var validPageExnameIndex = gsURL.urlPageFilePath.indexOf(validPageExname);
     if (validPageExnameIndex==-1
     || validPageExnameIndex+validPageExname.length!=gsURL.urlPageFilePath.length)
     {
     return false;
     }

     var urlPagePureFileNameForRegExp = gsURL.urlPagePureFileName.replaceAll("_", "");
     if (gsURL.urlPagePureFileName.indexOf("Content-")!=-1)
     {
     var contentSign = "Content-";
     gsURL.urlPagePureFileName
     = gsURL.urlPagePureFileName.substring(contentSign.length, gsURL.urlPagePureFileName.length);
     }
     var nubmerRegExp = new RegExp("^[0-9]*$");
     if (!nubmerRegExp.test(urlPagePureFileNameForRegExp))
     {
     return false;
     }
     return true;
     */
}
function gsGetTheImgSrc(img)
{
    return img.getAttribute("src");
}
function gsSetTheImgSrc(img, src)
{
    img.setAttribute("src", src);
    return;

    if (gsIsCurrentOSIOS())
    {
        img.setAttribute("src", src);
    }
    else
    {
        img.src = src;
    }
}
function gsSetElementClass(element, classNameNeedRemoved, classNameNeedAdded)
{
    if (element==null)
    {
        return;
    }

    if (classNameNeedAdded==null
        || classNameNeedAdded.length<1)
    {
        if (classNameNeedRemoved!=null
            && classNameNeedRemoved.length>0
            && element.className!=null
            && element.className.length>0)
        {
            element.className = element.className.replaceAll(classNameNeedRemoved, "");
        }
    }
    else if (element.className==null
        || element.className.length<1)
    {
        element.className = classNameNeedAdded;
    }
    else if (classNameNeedRemoved!=null
        && classNameNeedRemoved.length>0
        && element.className.indexOf(classNameNeedRemoved)!=-1)
    {
        element.className = element.className.replaceAll(classNameNeedRemoved, classNameNeedAdded);
    }
    else if (element.className.indexOf(classNameNeedAdded)==-1)
    {
        element.className += " "+classNameNeedAdded;
    }
}
function gsIsElementClass(element, className)
{
    if (element==null
        || element.className==null
        || className==null)
    {
        return false;
    }
    return element.className.match(new RegExp('(\\s|^)'+className+'(\\s|$)'));
}
function gsGetObjectParentWithTag(obj, tagName)
{
    if (obj!=null)
    {
        if (tagName==null
            || tagName.length<1)
        {
            return obj.parentNode;
        }

        for (var parentNode=obj.parentNode;
             parentNode!=null;
             parentNode=parentNode.parentNode)
        {
            if (parentNode.tagName==tagName)
            {
                return parentNode;
            }
        }
    }
    return null;
}
function gsGetObjectParentWithClass(obj, className)
{
    if (obj!=null)
    {
        if (className==null
            || className.length<1)
        {
            return obj.parentNode;
        }

        for (var parentNode=obj.parentNode;
             parentNode!=null;
             parentNode=parentNode.parentNode)
        {
            if (gsIsElementClass(parentNode, className))
            {
                return parentNode;
            }
        }
    }
    return null;
}
function gsGetObjectParentUnderBody(obj)
{
    if (obj!=null)
    {
        var lastParentNode = obj;
        for (var parentNode=obj.parentNode;
             parentNode!=null;
             parentNode=parentNode.parentNode)
        {
            if (parentNode.tagName=="BODY")
            {
                return lastParentNode;
            }
            lastParentNode = parentNode;
        }
    }
    return null;
}
// 由于网页元素情况极为复杂
// 所以这里指针对游民内容进行判断
function gsIsObjectsContinuous(fromObj, toObj)
{
    if (fromObj==null
        || toObj==null)
    {
        return false;
    }

    // 1. 新闻内连续图片,例: 高清视频截图
    var fromParentPTag = gsGetObjectParentWithTag(fromObj, "P");
    var toParentPTag = gsGetObjectParentWithTag(toObj, "P");
    if (fromParentPTag==null
        || toParentPTag==null)
    {
        return false;
    }

    var objectsContinuous = true;
    for (var parentNextSibling=fromParentPTag.nextSibling;
         parentNextSibling!=null && parentNextSibling!=toParentPTag;
         parentNextSibling=parentNextSibling.nextSibling)
    {
        if (parentNextSibling.clientHeight>0)
        {
            if (parentNextSibling.childNodes==null
                || parentNextSibling.childNodes.length<1)
            {
                var finalText = parentNextSibling.innerText;
                if (finalText!=null)
                {
                    finalText = finalText.replaceAll(" ", "");
                }

                if (finalText!=null
                    && finalText.length>0)
                {
                    objectsContinuous = false;
                    break;
                }
            }
            else
            {
                objectsContinuous = false;
                break;
            }
        }
    }

    return objectsContinuous;
}
function gsSendMessageToSuperWebView(msg)
{
    if (gsIsCurrentOSAndroid())
    {
        document.location = msg;
    }
    else
    {
        var aTag = document.createElement("a");
        aTag.href = msg;
        aTag.click();
    }
}
function gsPostToURL(url, postData, useAPIHeader, callBackFuncationName)
{
    if (url==null
        || url.length<1)
    {
        return;
    }

    if (postData==null)
    {
        postData = "";
    }
    else if (postData.length>0)
    {
        postData = postData.replaceAll("\"", "\\\"");
    }

    if (useAPIHeader==null
        || typeof(useAPIHeader)=="undefined"
        || !useAPIHeader)
    {
        useAPIHeader = "no";
    }
    else
    {
        useAPIHeader = "yes";
    }

    if (callBackFuncationName==null
        || typeof(callBackFuncationName)=="undefined")
    {
        callBackFuncationName = "";
    }


    var msg
        = "gsApp://post.app.gamersky?{"
        + "\"url\":\"" + url + "\", "
        + "\"data\":\"" + postData + "\", "
        + "\"useAPIHeader\":\"" + useAPIHeader + "\", "
        + "\"callBackFuncationName\":\"" + callBackFuncationName + "\"}";

    gsSendMessageToSuperWebView(msg);

}
function gsOpenTheArticelWithId(articelId)
{
    var openTopicURL
        = "openPage:{\"pageID\":\"" + articelId +"\","
        + "\"pageURL\":\"\","
        + "\"openMethod\":\"withContentID\"}";
    gsSendMessageToSuperWebView(openTopicURL);
}
function gsOpenTheArticelWithURL(articelURL)
{
    var openTopicURL
        = "openPage:{\"pageID\":\"\","
        + "\"pageURL\":\"" + articelURL + "\","
        + "\"openMethod\":\"withContentURL\"}";
    gsSendMessageToSuperWebView(openTopicURL);
}
function gsOpenTheTopicWithId(topicId)
{
    var openTopicURL
        = "openPage:{\"pageID\":\"" + topicId +"\","
        + "\"pageURL\":\"openTheSubscribeTopic.app.gamersky\","
        + "\"openMethod\":\"withContentURL\"}";
    gsSendMessageToSuperWebView(openTopicURL);
}
function gsSubscribeTheTopicWithId(topicId)
{
    var subscribeTopicURL
        = "openPage:{\"pageID\":\"" + topicId +"\","
        + "\"pageURL\":\"subscribeTheTopic.app.gamersky\","
        + "\"openMethod\":\"withContentID\"}";

    gsSendMessageToSuperWebView(subscribeTopicURL);

    event.currentTarget.onclick
        = function()
    {
        gsCancelSubscribeTheTopicWithId(topicId);
    };
    var buttons = event.currentTarget.getElementsByClassName("Button");
    if (buttons!=null && buttons.length>0)
    {
        for (var buttonIndex in buttons)
        {
            var button = buttons[buttonIndex];
            button.className = "Button Readed";
            button.innerHTML = "已订阅";
        }
    }
}
function gsCancelSubscribeTheTopicWithId(topicId)
{
    var subscribeTopicURL
        = "openPage:{\"pageID\":\"" + topicId +"\","
        + "\"pageURL\":\"cancelSubscribeTheTopic.app.gamersky\","
        + "\"openMethod\":\"withContentID\"}";

    gsSendMessageToSuperWebView(subscribeTopicURL);

    event.currentTarget.onclick
        = function()
    {
        gsSubscribeTheTopicWithId(topicId);
    };
    var buttons = event.currentTarget.getElementsByClassName("Button");
    if (buttons!=null && buttons.length>0)
    {
        for (var buttonIndex in buttons)
        {
            var button = buttons[buttonIndex];
            button.className = "Button";
            button.innerHTML = "订阅";
        }
    }
}
function gsGetTheGSElementWithGSElementID(gsElementID)
{
    try
    {
        gsElementID = gsElementID.toString();
        var mainBody = document.getElementById("gsTemplateContent_MainBody");
        var allElements = mainBody.getElementsByTagName("*");
        var allElementsCount = allElements.length;
        for (var elementIndex=0;
             elementIndex<allElementsCount;
             elementIndex++)
        {
            var element = allElements[elementIndex];
            if (element.getAttribute("gsElementID")==gsElementID)
            {
                return element;
            }
        }
    }
    catch(err){}
    return null;
}
function gsGetTheImageAdditionalInform(img)
{
    if (img==null || img.tagName.toLowerCase()!="img")
    {
        return "{\"caption\":\"\", \"hdImageURL\":\"\"}";
    }

    var imgCaption = "";

    var imgBoxer = img.parentNode;
    if (imgBoxer!=null
        && gsIsElementClass(imgBoxer, "ImgBoxer"))
    {
        var nextBrTag = imgBoxer.nextElementSibling;
        if (nextBrTag!=null
            && nextBrTag.tagName=="BR")
        {
            for (var nextSibling=nextBrTag.nextSibling;
                 nextSibling!=null;
                 nextSibling=nextSibling.nextSibling)
            {
                if (nextSibling.nodeType==3)
                {
                    imgCaption = nextSibling.data;
                    if (imgCaption!=null
                        && imgCaption.length>0)
                    {
                        break;
                    }
                }
                else if (nextSibling.tagName!="SPAN")
                {
                    break;
                }
            }
        }
        if (imgCaption==null
            || imgCaption.length<1)
        {
            var parentPTag = gsGetObjectParentWithTag(imgBoxer, "P");
            if (parentPTag!=null
                && parentPTag.nextElementSibling!=null
                && parentPTag.nextElementSibling.tagName=="P")
            {
                var nextPTag = parentPTag.nextElementSibling;
                imgCaption = nextPTag.textContent;
            }
        }
    }

    if (imgCaption.length>0)
    {
        if (gsIsCurrentOSAndroid())
        {
            imgCaption = imgCaption.replace(/[\r\n]/g, "");
            imgCaption = imgCaption.replace(/["]/g, "\\\"");
        }
        else
        {
            imgCaption = imgCaption.replaceAll(" ", "");
            imgCaption = imgCaption.replaceAll("\r\n", "");
            imgCaption = imgCaption.replaceAll("\r", "");
            imgCaption = imgCaption.replaceAll("\n", "");
            imgCaption = imgCaption.replaceAll("\"", "\\\"");
        }
    }

    var imgHDImageURL = img.getAttribute("hdImageURL");
    if (imgHDImageURL==null)
    {
        imgHDImageURL = "";
    }
    if (imgHDImageURL.length>0)
    {
        imgHDImageURL = imgHDImageURL.replaceAll(" ", "");
        imgHDImageURL = imgHDImageURL.replaceAll("\r\n", "");
        imgHDImageURL = imgHDImageURL.replaceAll("\r", "");
        imgHDImageURL = imgHDImageURL.replaceAll("\n", "");
        imgHDImageURL = imgHDImageURL.replace(/[\r\n]/g, "");
    }

    return "{\"caption\":\"" + imgCaption + "\", \"hdImageURL\":\"" + imgHDImageURL + "\"}";
}
function gsGetTheImageAdditionalInformWithGSID(imgGSID)
{
    return gsGetTheImageAdditionalInform(gsGetTheGSElementWithGSElementID(imgGSID));
}
function gsScrollToTheGSElement(gsElementID)
{
    var gsElement = gsGetTheGSElementWithGSElementID(gsElementID);
    var gsElementLeft = 0;
    var gsElementTop = 0;
    var gsElementWidth = 0;
    var gsElementHeight = 0;
    if (gsElement!=null
        && gsElement.parentNode!=null
        && gsIsElementClass(gsElement.parentNode,"ImgBoxer"))
    {
        var imgBoxer = gsElement.parentNode;
        var imgSetIndex = imgBoxer.getAttribute("ImgSetIndex");
        var indexInImgSet = imgBoxer.getAttribute("IndexInImgSet");

        if (imgSetIndex!=null
            && _kGSImgSetInfes!=null
            && imgSetIndex>=0
            && imgSetIndex<_kGSImgSetInfes.length)
        {
            var imgSetInfo = _kGSImgSetInfes[imgSetIndex];
            if (imgSetInfo.setType==_kGSImgSetType_Set)
            {
                gsSetTheImgSetCoverImgBoxer(imgSetInfo, indexInImgSet);
            }
        }

        gsElementLeft = gsElement.offsetLeft;
        gsElementTop = gsElement.offsetTop;
        gsElementWidth = gsElement.scrollWidth;
        gsElementHeight= gsElement.scrollHeight;

        var gsElementBottom = gsElementTop+gsElementHeight;
        var windowBottom = window.scrollY+window.innerHeight;
        var windowScrollObjectY = window.scrollY;
        if (gsElementTop>=windowBottom
            || gsElementBottom<window.scrollY)
        {
            windowScrollObjectY = gsElementTop - 10.0;
        }
        else if (gsElementTop<window.scrollY
            && gsElementBottom>window.scrollY)
        {
            windowScrollObjectY = gsElementTop - 10.0;
        }
        else if (gsElementTop<windowBottom
            && gsElementBottom>windowBottom)
        {
            windowScrollObjectY += gsElementBottom - windowBottom + 10.0;
        }
        window.scroll(0,windowScrollObjectY);
    }
    return '{"left":'+gsElementLeft
        +', "top":'+gsElementTop
        +', "width":'+gsElementWidth
        +', "height":'+gsElementHeight+'}';
}
var kGSValidBoundsExtendRate = 1.0;
function gsGetCurrentViewArea()
{
    var viewArea = new function(){};
    viewArea.left = window.scrollX;
    viewArea.right = window.scrollX+window.innerWidth;
    viewArea.top = window.scrollY-window.innerHeight*kGSValidBoundsExtendRate;
    viewArea.bottom =  window.scrollY+window.innerHeight*(1.0+kGSValidBoundsExtendRate);

    //viewArea.top = window.scrollY-window.innerHeight/10.0;
    //viewArea.bottom =  window.scrollY+window.innerHeight*10.0;

    viewArea.width = viewArea.right-viewArea.left;
    viewArea.height = viewArea.bottom-viewArea.top;
    return viewArea;
}
function gsGetGSElementsInCurrentViewArea()
{
    var validElementIDs = "";
    var invalidElementIDs = "";
    try
    {
        var gsElements
        var viewArea = gsGetCurrentViewArea();
        var viewAreaLeft = viewArea.left;
        var viewAreaTop = viewArea.top;
        var viewAreaRight = viewArea.right;
        var viewAreaBottom = viewArea.bottom;

        var allElements = document.getElementsByTagName("*");
        var allElementsCount = allElements.length;
        for (var elementIndex=0;
             elementIndex<allElementsCount;
             elementIndex++)
        {
            var element = allElements[elementIndex];
            var gsElementID = element.getAttribute("gsElementID");
            if (gsElementID!=null
                && !gsIsElementClass(element, "GSTemplateImageLoader"))
            {
                var elementIndexInImgSet = element.getAttribute("indexInImgSet");
                if (elementIndexInImgSet==null
                    || elementIndexInImgSet=="undefined"
                    || elementIndexInImgSet=="0")
                {
                    var gsElementLeft = element.offsetLeft;
                    var gsElementTop = element.offsetTop;
                    var gsElementRight = gsElementLeft+element.scrollWidth;
                    var gsElementBottom = gsElementTop+element.scrollHeight;

                    if (gsElementLeft<viewAreaRight
                        && gsElementRight>viewAreaLeft
                        && gsElementTop<viewAreaBottom
                        && gsElementBottom>viewAreaTop)
                    {
                        validElementIDs += "\"" + gsElementID +"\",";
                    }
                    else
                    {
                        invalidElementIDs += "\"" + gsElementID +"\",";
                    }
                }
            }
        }

        if (validElementIDs.length>0)
        {
            validElementIDs
                = validElementIDs.substring(0, validElementIDs.length-1);
        }
        if (invalidElementIDs.length>0)
        {
            invalidElementIDs
                = invalidElementIDs.substring(0, invalidElementIDs.length-1);
        }
    }
    catch(err)
    {
        validElementIDs = "";
        invalidElementIDs = "";
    }
    return "{\"validElementIDs\":[" + validElementIDs + "], "
        + "\"invalidElementIDs\":[" + invalidElementIDs + "]}";
}
function gsIsTheImgGIFAnimationThumbnail(img)
{
    var isGIFAnimationThumbnail = false;
    try
    {
        /*
         if (gsIsCurrentOSIOS())
         {
         isGIFAnimationThumbnail
         = typeof(img.getAttribute("srcType"))!="undefined"
         && img.getAttribute("srcType")=="GIFAnimationThumbnail";
         }
         else
         */
        {
            isGIFAnimationThumbnail
                = gsGetTheImgSrc(img).toLowerCase().indexOf(".gif")!=-1;

            if (isGIFAnimationThumbnail==false)
            {
                isGIFAnimationThumbnail
                    =  img.getAttribute("originSrc")!=null
                    && img.getAttribute("originSrc").toLowerCase().indexOf(".gif")!=-1;
            }
            if (isGIFAnimationThumbnail==false)
            {
                isGIFAnimationThumbnail
                    =  img.getAttribute("ori_link")!=null
                    && img.getAttribute("ori_link").toLowerCase().indexOf(".gif")!=-1;
            }
        }
    }
    catch (err)
    {
    }
    return isGIFAnimationThumbnail;
}
function gsAdjustTheImgBoxerBgColor(imgBoxer, forceUpdate)
{
    if (imgBoxer==null)
    {
        return;
    }

    var isImgValid = false;
    var imgsInBoxer = imgBoxer.getElementsByTagName("img");
    if (imgsInBoxer!=null
        && imgsInBoxer.length>0)
    {
        isImgValid = imgsInBoxer[0].style.visible=="visible";
    }

    if (isImgValid)
    {
        imgBoxer.style.backgroundColor = "transparent";
    }
    else if (_kGSIsNightColorModeBuffer)
    {
        imgBoxer.style.backgroundColor = "#1B1A1F";
    }
    else
    {
        imgBoxer.style.backgroundColor = "#eeeeee";
    }
}
function gsSetTheImgBoxerBgType(imgBoxer, bgType, bgParam)
{
    if (imgBoxer==null)
    {
        return;
    }

    // 统一设置
    gsAdjustTheImgBoxerBgColor(imgBoxer, false);
    imgBoxer.style.backgroundPosition = "center center";
    imgBoxer.style.backgroundRepeat = "no-repeat";
    imgBoxer.onclick = gsImageBoxerOnClick;

    // 独立设置
    switch (bgType)
    {
        case "default":
        {
            var imgBoxerBackgroundImage
                = "url(gsAppHTMLTemplate_image/gsAppHTMLTemplate_ImgBoxer_Background@2x.png)";
            imgBoxer.style.backgroundImage = imgBoxerBackgroundImage;
            imgBoxer.style.backgroundSize = "240px 60px";
        }break;
        case "nullImageMode":
        {
            var imgBoxerBackgroundImage
                = "url(gsAppHTMLTemplate_image/gsAppHTMLTemplate_ImgBoxer_LoadTheImage@2x.png)";
            imgBoxer.style.backgroundImage = imgBoxerBackgroundImage;
            imgBoxer.style.backgroundSize = "100px 100px";

            imgBoxer.onclick = gsReloadTheImgBoxerImage;
        }break;
        case "progress":
        {
            if (_kGSIsCurrentAppNullImageProgressVersion)
            {
                var imgBoxerBackgroundImage
                    = "url(gsAppHTMLTemplate_image/gsAppHTMLTemplate_ImgBoxer_Background@2x.png)";
                imgBoxer.style.backgroundImage = imgBoxerBackgroundImage;
                imgBoxer.style.backgroundSize = "240px 60px";
            }
            else
            {
                imgBoxer.style.backgroundImage
                    = "url(gsAppHTMLTemplate_image/gsAppHTMLTemplate_ImgBoxer_BackgroundProgress" + bgParam + ".png)";
                imgBoxer.style.backgroundSize = "240px 60px";
            }
        }break;
        case "loadFailed":
        {
            imgBoxer.style.backgroundImage
                = "url(gsAppHTMLTemplate_image/gsAppHTMLTemplate_ImgBoxer_BackgroundLoadFailed@2x.png)";
            imgBoxer.style.backgroundSize
                = "76px 76px";

            imgBoxer.onclick = gsReloadTheImgBoxerImage;
        }break;
        case "none":
        {
            imgBoxer.style.backgroundColor = "transparent"
            imgBoxer.style.backgroundImage = "none";
        }break;
    }
}
function gsSetTheImgElementParam(img, param)
{
    if (img==null || param==null)
    {
        return;
    }

    switch (param.name)
    {
        case "state":
        {
            switch (param.value)
            {
                case "loadFailed":
                {
                    if (gsIsElementClass(img.parentNode, "ImgBoxer"))
                    {
                        gsSetTheImgBoxerBgType(img.parentNode, "loadFailed", null);
                    }
                }break;
            }
        }break;
        case "progress":
        {
            if (gsIsElementClass(img.parentNode, "ImgBoxer"))
            {
                var parentImgBoxer = img.parentNode;

                // 图片已加载
                if (gsGetTheImgSrc(img)==""
                    || img.style.visibility!="visible")
                {
                    var progressValue = Math.floor(10*param.value)*10;
                    gsSetTheImgBoxerBgType(parentImgBoxer, "progress", progressValue);
                }
            }
        }break;
        case "src":
        {
            try
            {
                gsSetTheImgSrc(img, param.value);

                var imgSrcValid = false;
                var imgSrc = gsGetTheImgSrc(img);
                if (imgSrc==null
                    || imgSrc.length<1)
                {
                    imgSrcValid = false;
                }
                else
                {
                    imgSrcValid = true;
                }
                var imgSrcType = img.getAttribute("srcType");
                if (imgSrcType!=null)
                {
                    img.srcType = imgSrcType;
                }


                if (imgSrcValid)
                {
                    img.style.visibility = "visible";
                    if (gsIsElementClass(img.nextSibling, "ImgBoxerStatusBar"))
                    {
                        img.nextSibling.style.visibility = "visible";
                    }
                }
                else
                {
                    img.style.visibility = "hidden";
                }
            }
            catch (exception)
            {}
        }break;
    }
}

function gsCreateTheCommentReplyCommentsHTML(comment)
{
    if (comment==null
        || comment.replyComments==null
        || comment.replyComments.length<1)
    {
        return "";
    }

    var replyCommentsHTML = "";
    var replyComments = comment.replyComments;
    var replyCommentsCount = replyComments.length;
    for (var replyCommentIndex=0;
         replyCommentIndex<replyCommentsCount;
         replyCommentIndex++)
    {
        var replyComment = replyComments[replyCommentIndex];
        if (replyComment!=null)
        {
            var replyCommentContentClass
                = "ReplyCommentContent";
            var replyCommentContentOperateBarClass
                = "ReplyCommentContentOperateBar";
            if (replyCommentIndex+1==replyCommentsCount)
            {
                replyCommentContentClass = "LastReplyCommentContent";
                replyCommentContentOperateBarClass = "ReplyCommentContentOperateBar LastReplyCommentContentOperateBar";
            }

            var originCommentContent
                = replyComment.content;
            var finalCommentContent
                = originCommentContent;
            if (originCommentContent.length>60)
            {
                finalCommentContent
                    = originCommentContent.substring(0, 50)
                    + "..."
                    + "<a class=\"ShowOriginContentButton\" onclick=\"gsCommentShowCurrentCommentOriginContent(this);event.stopPropagation();return false;\">显示全部</a>";
            }

            var moreFloorsButtonHTML = "";

            var replyCommentCSS = "";
            if (replyCommentsCount>3)
            {
                if (replyCommentIndex==2)
                {
                    moreFloorsButtonHTML
                        = "<div class=\"ReplyComment ReplyCommentContent ShowMoreFloorsButton\" onclick=\"gsCommentShowHiddenFloors(this);event.stopPropagation();\">显示隐藏楼层</div>";
                }

                if (replyCommentIndex>1
                    && replyCommentIndex<replyCommentsCount-1)
                {
                    replyCommentCSS = "display:none;";
                }
            }
            replyCommentsHTML += moreFloorsButtonHTML;


            var replyCommentHTML
                = "<div class=\"ReplyComment\" style=\"" + replyCommentCSS + "\">"
                + "<div class=\"ReplyCommentTitle\">" + replyComment.userNickName + "<span class=\"ReplyCommentFloorIndex\">" + (replyCommentIndex+1) + "</span></div>"
                + "<div class=\"" + replyCommentContentClass + "\" origincommentcontent=\"" + originCommentContent + "\">" + finalCommentContent + "</div>"
                + "<div class=\"" + replyCommentContentOperateBarClass + "\">"
                + "<div class=\"PraiseButton\" onclick=\"gsCommentPraiseTheComment('" + replyComment.id.toString() + "', this);event.stopPropagation();\">"
                + "<div class=\"Icon\"></div>"
                + "<div class=\"Label\">" + replyComment.praisesCount + "</div>"
                + "</div>"
                + "<div class=\"ReplyButton\" onclick=\"gsCommentReplyTheComment('" + replyComment.id.toString() + "', this);event.stopPropagation();\">回复</div>"
                + "</div>"
                + "</div>";

            replyCommentsHTML += replyCommentHTML;
        }
    }
    if(replyCommentsHTML!=null
        && replyCommentsHTML.length>0)
    {
        replyCommentsHTML
            = "<div class=\"ReplyComments\">"
            + replyCommentsHTML
            + "</div>";
    }

    return replyCommentsHTML;
}

function gsCreateTheCommentHTML(comment)
{
    if (comment==null)
    {
        return "";
    }

    var userHeadImageHTML = "";
    if (comment.userHeadImageURL!=null
        && comment.userHeadImageURL.length>0)
    {
        userHeadImageHTML = "<img width=\"100%\" height=\"100%\" src=\"" +comment.userHeadImageURL+ "\" />";
    }

    var userSubtitle = "";
    /*
     var userIPLocation = comment.userIPLocation;
     if (userIPLocation!=null
     && userIPLocation.length>0)
     {
     var indexOfQu = userIPLocation.indexOf("区");
     if (indexOfQu>-1
     && indexOfQu<(userIPLocation.length-1))
     {
     userIPLocation = userIPLocation.substring(indexOfQu+1);
     }

     userSubtitle = userIPLocation + " " + comment.dateTime;
     }
     else
     */
    {
        userSubtitle = comment.dateTime;
    }

    var replyCommentsHTML = gsCreateTheCommentReplyCommentsHTML(comment);

    var originCommentContent
        = comment.content;
    var finalCommentContent
        = originCommentContent;

    if (originCommentContent.length>60)
    {
        finalCommentContent
            = originCommentContent.substring(0, 50)
            + "..."
            + "<a class=\"ShowOriginContentButton\" onclick=\"gsCommentShowCurrentCommentOriginContent(this);event.stopPropagation();return false;\">显示全部</a>";
    }

    return "<li class=\"li\">"
        + "<div class=\"comment-header\">"
        + "<div class=\"header-wrap\">"
        + "<div class=\"box-pic\">" + userHeadImageHTML + "</div>"
        + "<div class=\"box-msg\">"
        + "<div class=\"msg-name\">" + comment.userNickName + "</div>"
        + "<div class=\"msg-time\">" + userSubtitle + "</div>"
        + "</div>"
        + "</div>"
        + "<div class=\"header-reply\" onclick=\"gsCommentReplyTheComment('" + comment.id.toString() + "', this);event.stopPropagation();\">回复</div>"
        + "<div class=\"header-praise\" onclick=\"gsCommentPraiseTheComment('" + comment.id.toString() + "', this);event.stopPropagation();\">"
        + "<div class=\"Icon\"></div>"
        + "<div class=\"Label\">" + comment.praisesCount + "</div>"
        + "</div>"
        + "</div>"
        + "<div class=\"comment-cont\">"
        + replyCommentsHTML
        + "<div originCommentContent=\""
        + originCommentContent
        + "\">" + finalCommentContent + "</div>"
        + "</div>"
        + "</li>";
}

function gsCommentShowCurrentCommentOriginContent(showButtonInContent)
{
    if (showButtonInContent==null)
    {
        return;
    }
    var contentOwner = showButtonInContent.parentNode;
    if (contentOwner==null)
    {
        return;
    }
    var originCommentContent = contentOwner.getAttribute("originCommentContent");
    if (originCommentContent==null
        || originCommentContent.length<1)
    {
        return;
    }
    contentOwner.innerHTML
        = originCommentContent;
}

function gsCommentPraiseTheComment(commentID, praiseContentOwner)
{
    if (commentID==null
        || commentID.length<1)
    {
        return;
    }

    var praiseIconContents
        = praiseContentOwner.getElementsByClassName("Icon");
    if (praiseIconContents==null
        || praiseIconContents.length<1)
    {
        return;
    }
    var praiseIconContent = praiseIconContents[0];

    var praiseNumberContent = null;
    var praiseNumberContents = praiseContentOwner.getElementsByClassName("Label");
    if (praiseNumberContents!=null
        && praiseNumberContents.length>0)
    {
        praiseNumberContent = praiseNumberContents[0];
    }

    if (praiseIconContent.className.indexOf("IconSelected")>-1)
    {
        gsSendMessageToSuperWebView("openPage:{\"openMethod\":\"withContentURL\", \"pageID\":\""
            + commentID
            + "\", \"pageURL\":\"treadTheComment.app.gamersky\"}");

        praiseIconContent.className = "Icon";
        if (praiseNumberContent!=null)
        {
            praiseNumberContent.innerHTML
                = (parseInt(praiseNumberContent.textContent)-1);
        }
    }
    else
    {
        gsSendMessageToSuperWebView("openPage:{\"openMethod\":\"withContentURL\", \"pageID\":\""
            + commentID
            + "\", \"pageURL\":\"praiseTheComment.app.gamersky\"}");

        praiseIconContent.className = "Icon IconSelected";
        if (praiseNumberContent!=null)
        {
            praiseNumberContent.innerHTML
                = (parseInt(praiseNumberContent.textContent)+1);
        }
    }
}

function gsCommentTreadTheComment(commentID, praiseContentOwner)
{
    if (commentID==null
        || commentID.length<1)
    {
        return;
    }

    gsSendMessageToSuperWebView("openPage:{\"openMethod\":\"withContentURL\", \"pageID\":\""
        + commentID
        + "\", \"pageURL\":\"praiseTheComment.app.gamersky\"}");

    if (praiseContentOwner!=null)
    {
        var praiseNumberContents
            = praiseContentOwner.getElementsByClassName("Label");
        var praiseNumberContentsCount
            = praiseNumberContents.length;
        for (var praiseNumberContentIndex=0;
             praiseNumberContentIndex<praiseNumberContentsCount;
             praiseNumberContentIndex++)
        {
            var praiseNumberContent
                = praiseNumberContents[praiseNumberContentIndex];
            praiseNumberContent.innerHTML
                = (parseInt(praiseNumberContent.textContent)+1);
        }

        var praiseIconContents
            = praiseContentOwner.getElementsByClassName("Icon");
        var praiseIconContentsCount
            = praiseIconContents.length;
        for (var praiseIconContentIndex=0;
             praiseIconContentIndex<praiseIconContentsCount;
             praiseIconContentIndex++)
        {
            var praiseIconContent
                = praiseIconContents[praiseIconContentIndex];
            praiseIconContent.className = "IconSelected";
        }

        // praiseContentOwner.onclick = null;
    }
}

function gsCommentReplyTheComment(commentID, praiseContentOwner)
{
    if (commentID==null
        || commentID.length<1)
    {
        return;
    }

    {
        gsSendMessageToSuperWebView("openPage:{\"openMethod\":\"withContentURL\", \"pageID\":\""
            + commentID
            + "\", \"pageURL\":\"replyTheComment.app.gamersky\"}");

        if (praiseContentOwner!=null)
        {
            var praiseNumberContents
                = praiseContentOwner.getElementsByClassName("Label");
            var praiseNumberContentsCount
                = praiseNumberContents.length;
            for (var praiseNumberContentIndex=0;
                 praiseNumberContentIndex<praiseNumberContentsCount;
                 praiseNumberContentIndex++)
            {
                var praiseNumberContent
                    = praiseNumberContents[praiseNumberContentIndex];
                praiseNumberContent.innerHTML
                    = (parseInt(praiseNumberContent.textContent)+1);
            }

            var praiseIconContents
                = praiseContentOwner.getElementsByClassName("Icon");
            var praiseIconContentsCount
                = praiseIconContents.length;
            for (var praiseIconContentIndex=0;
                 praiseIconContentIndex<praiseIconContentsCount;
                 praiseIconContentIndex++)
            {
                var praiseIconContent
                    = praiseIconContents[praiseIconContentIndex];
                praiseIconContent.className = "IconSelected";
            }

            // praiseContentOwner.onclick = null;
        }
    }
}

function gsCommentShowHiddenFloors(showButton)
{
    if (showButton==null)
    {
        return;
    }
    var floorsOwner = showButton.parentNode;
    if (floorsOwner==null)
    {
        return;
    }
    var replyCommentFloors
        = document.getElementsByClassName("ReplyComment");
    if (replyCommentFloors==null
        || replyCommentFloors.length<1)
    {
        return;
    }

    var replyCommentFloorsCount = replyCommentFloors.length;
    for (var replyCommentFloorIndex=0;
         replyCommentFloorIndex<replyCommentFloorsCount;
         replyCommentFloorIndex++)
    {
        var replyCommentFloor = replyCommentFloors[replyCommentFloorIndex];
        replyCommentFloor.style.display = "block";
    }
    showButton.style.display = "none";
}

function gsSetPageParam(param)
{
    if (typeof(param.name)=="undefined")
    {
        param = eval("(" + param + ")");
    }

    switch (param.name)
    {
        case "theme":
        case "pageColorMode":
        {
            var htmlTag = document.getElementsByTagName("html")[0];
            switch (param.value)
            {
                case "day":
                {
                    gsSetElementClass(htmlTag, "PageColorMode_Night", "PageColorMode_Day");
                    if (typeof(kDefaultPageColorMode)!="undefined")
                    {
                        kDefaultPageColorMode = "day";
                        _kGSIsNightColorModeBuffer = false;
                    }
                }break;
                case "night":
                {
                    gsSetElementClass(htmlTag, "PageColorMode_Day", "PageColorMode_Night");
                    if (typeof(kDefaultPageColorMode)!="undefined")
                    {
                        kDefaultPageColorMode = "night";
                        _kGSIsNightColorModeBuffer = true;
                    }
                }break;
            }

            var imgBoxes = document.getElementsByClassName("ImgBoxer");
            if (imgBoxes!=null
                && imgBoxes.length>0)
            {
                var imgBoxesCount = imgBoxes.length;
                for (var imgBoxIndex=0;
                     imgBoxIndex<imgBoxesCount;
                     imgBoxIndex++)
                {
                    var imgBoxer = imgBoxes[imgBoxIndex];
                    gsAdjustTheImgBoxerBgColor(imgBoxer, false);
                }
            }
        }break;
        case "pageFontSize":
        {
            var htmlTag = document.getElementsByTagName("html")[0];
            if (typeof(kDeviceIsBigScreen)!="undefined"
                && kDeviceIsBigScreen=="yes")
            {
                switch (param.value)
                {
                    case "min":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_MiddleForBigScreen", "");
                        gsSetElementClass(htmlTag, "PageFontSize_MaxForBigScreen", "PageFontSize_MinForBigScreen");
                    }break;
                    case "middle":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_MinForBigScreen", "");
                        gsSetElementClass(htmlTag, "PageFontSize_MaxForBigScreen", "PageFontSize_MiddleForBigScreen");
                    }break;
                    case "max":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_MinForBigScreen", "");
                        gsSetElementClass(htmlTag, "PageFontSize_MiddleForBigScreen", "PageFontSize_MaxForBigScreen");
                    }break;
                }
            }
            else
            {
                switch (param.value)
                {
                    case "min":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_Middle", "");
                        gsSetElementClass(htmlTag, "PageFontSize_Max", "PageFontSize_Min");
                    }break;
                    case "middle":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_Min", "");
                        gsSetElementClass(htmlTag, "PageFontSize_Max", "PageFontSize_Middle");
                    }break;
                    case "max":
                    {
                        gsSetElementClass(htmlTag, "PageFontSize_Min", "");
                        gsSetElementClass(htmlTag, "PageFontSize_Middle", "PageFontSize_Max");
                    }break;
                }
            }
        }break;
        case "nullImageMode":
        {
            var images = document.getElementsByTagName("img");
            if (param.value=="yes")
            {
                if (typeof(kDefaultNullImageMode)!="undefined")
                {
                    kDefaultNullImageMode = "yes";
                    _kGSIsNullImageModeBuffer = true;
                }

                for (var imgIndex=0;
                     imgIndex<images.length;
                     imgIndex++)
                {
                    var img = images[imgIndex];
                    img.style.visibility = "hidden";

                    if (gsIsElementClass(img.parentNode, "ImgBoxer"))
                    {
                        var imgBoxer = img.parentNode;
                        gsSetTheImgBoxerBgType(imgBoxer, "nullImageMode", null);
                    }
                }
            }
            else
            {
                if (typeof(kDefaultNullImageMode)!="undefined")
                {
                    kDefaultNullImageMode = "no";
                    _kGSIsNullImageModeBuffer = false;
                }

                for (var imgIndex=0;
                     imgIndex<images.length;
                     imgIndex++)
                {
                    var img = images[imgIndex];
                    if (gsGetTheImgSrc(img)!="")
                    {
                        img.style.visibility = "visible";

                        if (gsIsElementClass(img.parentNode, "ImgBoxer"))
                        {
                            var imgBoxer = img.parentNode;
                            gsSetTheImgBoxerBgType(imgBoxer, "none", null);
                        }
                        if (img.nextSibling!=null
                            && gsIsElementClass(img.nextSibling, "ImgBoxerStatusBar"))
                        {
                            img.nextSibling.style.visibility = "visible";
                        }
                    }
                    else
                    {
                        img.style.visibility = "hidden";

                        if (gsIsElementClass(img.parentNode, "ImgBoxer"))
                        {
                            var imgBoxer = img.parentNode;
                            gsSetTheImgBoxerBgType(imgBoxer, "loadFailed", null);
                        }
                    }
                }

                // 请求当前图片
                gsOnWindowScroll();
            }
        }break;
        case "gsTemplateContent_RelatedTopic":
        {
            var relatedTopicsHTML = "";
            var relatedTopics = param.value;
            if (relatedTopics!=null
                && relatedTopics.length!=null
                && relatedTopics.length>0)
            {
                var relatedTopicsCount = relatedTopics.length;
                for (var relatedTopicIndex=0;
                     relatedTopicIndex<relatedTopicsCount;
                     relatedTopicIndex++)
                {
                    var relatedTopic = relatedTopics[relatedTopicIndex];
                    var relatedTopicId = relatedTopic.topicId;
                    if (relatedTopicId==null
                        || relatedTopicId.length==null)
                    {
                        relatedTopicId = "";
                    }

                    var openTopicURL
                        = "gsOpenTheTopicWithId('" + relatedTopicId +"')";

                    var subscribeTopicURL = "";
                    var buttonHTML = "";

                    if (relatedTopic.subscribed)
                    {
                        subscribeTopicURL = "gsCancelSubscribeTheTopicWithId('" + relatedTopicId +"')";
                        buttonHTML = "<div class=\"Button Readed\">已订阅</div>";
                    }
                    else
                    {
                        subscribeTopicURL = "gsSubscribeTheTopicWithId('" + relatedTopicId +"')";
                        buttonHTML = "<div class=\"Button\">订阅</div>";
                    }

                    var relatedTopicHTML
                        = "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
                        + "<tr>"
                        + "<td class=\"Content\" align=\"left\" valign=\"middle\" onclick=\"" + openTopicURL + "\">"
                        + "<img src=\"" + relatedTopic.iconURL + "\">"
                        + "<span class=\"Title\">" + relatedTopic.title + "</span>"
                            /*
                             + "<br />"
                             + "<span class=\"Subtitle\">" + relatedTopic.subscribersCount + "人订阅</span>"
                             */
                        + "</td>"
                        + "<td class=\"ButtonArea\" align=\"center\" valign=\"middle\" onclick=\"" + subscribeTopicURL + "\">"
                        + buttonHTML
                        + "</td>"
                        + "</tr>"
                        + "</table>";

                    relatedTopicsHTML += relatedTopicHTML;
                }
            }

            var relatedTopicElement
                = document.getElementById("gsTemplateContent_RelatedTopic");
            if (relatedTopicElement!=null)
            {
                if (relatedTopicsHTML.length>0)
                {
                    var relatedTopicElementContent
                        = document.getElementById("gsTemplateContent_RelatedTopicContent");
                    if (relatedTopicElementContent!=null)
                    {
                        relatedTopicElementContent.innerHTML = relatedTopicsHTML;
                    }

                    // 显示
                    relatedTopicElement.style.display = "block";

                    // 关联操作
                    var relatedTopicContents = relatedTopicElement.getElementsByClassName("Content");
                    var relatedTopicButtons = relatedTopicElement.getElementsByClassName("Button");
                    try
                    {
                        for (var relatedTopicContentIndex in relatedTopicContents)
                        {
                            var relatedTopicContent = relatedTopicContents[relatedTopicContentIndex];
                            gsAddTouchEventListenerToObject(relatedTopicContent);

                            var relatedTopicButton = relatedTopicButtons[relatedTopicContentIndex];
                            gsAddTouchEventListenerToObject(relatedTopicButton);
                        }
                    }
                    catch(err)
                    {}
                }
                else
                {
                    relatedTopicElement.style.display = "none";
                }
            }
        }break;
        case "gsTemplateContent_RelatedReading":
        {
            var relatedReadingsHTML = "";
            var relatedReadings = param.value;
            if (relatedReadings!=null
                && relatedReadings.length!=null
                && relatedReadings.length>0)
            {
                var relatedTopicId = null;
                var relatedTopicName = null;
                for (var relatedReadingIndex in relatedReadings)
                {
                    var relatedReading = relatedReadings[relatedReadingIndex];
                    var relatedReadingPageID = relatedReading.pageID;
                    if (relatedReadingPageID==null
                        || relatedReadingPageID.length==null)
                    {
                        relatedReadingPageID = "";
                    }
                    var relatedReadingPageURL = relatedReading.pageURL;
                    if (relatedReadingPageURL==null
                        || relatedReadingPageURL.length==null)
                    {
                        relatedReadingPageURL = "";
                    }

                    if (relatedTopicId==null)
                    {
                        relatedTopicId = relatedReading.topicId;
                        relatedTopicName = relatedReading.topicName;
                    }

                    var relatedReadingURL
                        = "openPage:{\"pageID\":\"" + relatedReadingPageID +"\","
                        + "\"pageURL\":\"" + relatedReadingPageURL + "\","
                        + "\"openMethod\":\"default\"}";
                    relatedReadingURL = encodeURI(relatedReadingURL);

                    var relatedReadingHTML
                        = "<a href=\"" + relatedReadingURL + "\"><div class=\"Row\"><div>" + relatedReading.title + "</div></div></a>"

                    relatedReadingsHTML += relatedReadingHTML;
                }
                if (relatedReadingsHTML!=null
                    && relatedReadingsHTML.length>0
                    && relatedTopicId!=null
                    && relatedTopicName!=null)
                {
                    relatedReadingsHTML
                        += "<div class=\"Row Button\" onclick=\"gsOpenTheTopicWithId(\""
                        + relatedTopicId
                        + "\")\">点击查看更多["
                        + relatedTopicName
                        + "]新闻</div>";
                }
            }

            var relatedReadingElement
                = document.getElementById("gsTemplateContent_RelatedReading");
            if (relatedReadingElement!=null)
            {
                if (relatedReadingsHTML.length>0)
                {
                    var relatedReadingElementContent
                        = document.getElementById("gsTemplateContent_RelatedReadingContent");
                    if (relatedReadingElementContent!=null)
                    {
                        relatedReadingElementContent.innerHTML = relatedReadingsHTML;
                    }

                    // 显示
                    relatedReadingElement.style.display = "block";

                    // 关联操作
                    var rows = relatedReadingElement.getElementsByClassName("Row");
                    try
                    {
                        for (var rowIndex in rows)
                        {
                            var row = rows[rowIndex];
                            gsAddTouchEventListenerToObject(row);
                        }
                    }
                    catch(err)
                    {}

                    var buttons = relatedReadingElement.getElementsByClassName("Button");
                    try
                    {
                        for (var buttonIndex in buttons)
                        {
                            var button = buttons[buttonIndex];
                            gsAddTouchEventListenerToObject(button);
                        }
                    }
                    catch(err)
                    {}
                }
                else
                {
                    relatedReadingElement.style.display = "none";
                }
            }
        }break;
        case "gsTemplateContent_HotComments":
        case "gsTemplateContent_AllComments":
        case "gsTemplateContent_Comments":
        {
            var allCommentsType = null;
            if (param.name=="gsTemplateContent_HotComments")
            {
                allCommentsType = "hot";
            }
            else if (param.name=="gsTemplateContent_AllComments")
            {
                allCommentsType = "lastest";
            }
            else
            {
                allCommentsType = null;
            }

            var comments = param.value;
            if (comments!=null
                && comments.length!=null
                && comments.length>0)
            {
                var lastCommetnsType = null;
                var commentsHTML = "";

                var commentsCount = comments.length;
                for (var commentIndex=0;
                     commentIndex<commentsCount;
                     commentIndex++)
                {
                    var comment = comments[commentIndex];
                    var commentType = comment.type;
                    if (commentType==null
                        && allCommentsType!=null)
                    {
                        commentType = allCommentsType;
                    }

                    if (lastCommetnsType!=commentType)
                    {
                        lastCommetnsType = commentType;

                        if (commentsHTML.length>0)
                        {
                            commentsHTML += "</ul>";
                        }
                        switch (commentType)
                        {
                            case "hot":
                            {
                                commentsHTML
                                    += "<div class=\"tit blue\">热门评论</div>"
                                    + "<ul class=\"Comment\" id=\"hotComments\">";
                            }break;
                            case "lastest":
                            default:
                            {
                                commentsHTML
                                    += "<div class=\"tit blue\">最新评论</div>"
                                    + "<ul class=\"Comment\" id=\"lastestComments\">";
                            }break;
                        }
                    }

                    var commentHTML = gsCreateTheCommentHTML(comment);
                    commentsHTML += commentHTML;
                }
                if (commentsHTML.length>0)
                {
                    commentsHTML += "</ul><div class=\"Button More\">点击查看更多评论</div>";
                }
                var commentsElement
                    = document.getElementById("gsTemplateContent_Comments");
                if (commentsElement!=null)
                {
                    commentsElement.innerHTML = commentsHTML;
                    commentsElement.style.display = "block";
                }

                // 关联操作
                var buttons = commentsElement.getElementsByClassName("Button");
                try
                {
                    for (var buttonIndex in buttons)
                    {
                        var button = buttons[buttonIndex];
                        gsAddTouchEventListenerToObject(button);
                    }
                }
                catch(err)
                {}
            }
        }break;
        case "gsTemplateContent_NewComment":
        {
            var comment = param.value;
            var lastestComments = document.getElementById("lastestComments");
            if (lastestComments==null)
            {
                gsSetPageParam({"name":"gsTemplateContent_AllComments", "value":[comment]});
            }
            else
            {
                var commentHTML = gsCreateTheCommentHTML(comment);
                if (commentHTML!=null
                    && commentHTML.length>0)
                {
                    lastestComments.innerHTML
                        = commentHTML
                        + lastestComments.innerHTML;

                    // 关联操作
                    var buttons = lastestComments.getElementsByClassName("Button");
                    try
                    {
                        for (var buttonIndex in buttons)
                        {
                            var button = buttons[buttonIndex];
                            gsAddTouchEventListenerToObject(button);
                        }
                    }
                    catch(err)
                    {}
                }
            }
        }break;
        case "gsTemplateContent_AD1":
        {
            try
            {
                var ad = param.value;

                if (typeof(ad.contentType)=="undefined")
                {
                    // 1, 使用 contentURL
                    // 2, 使用 contentID
                    ad.contentType = 1;
                }
                if (typeof(ad.url)!="undefined")
                {
                    ad.contentURL = ad.url;
                }

                var openMethod = "withContentID";
                if (ad.contentType=="1")
                {
                    openMethod = "withContentURL";
                }
                else if (ad.contentType=="2")
                {
                    openMethod = "withContentID";
                }
                else
                {
                    openMethod = "default";
                }

                var adId = "adId";
                if (gsIsCurrentOSAndroid())
                {
                    adId = "adID";
                }
				
				if (ad.id==628)
				{
					ad.contentType = "withContentID";
					ad.contentID = "765526";
				}
				else if (ad.id==629)
				{
					ad.contentType = "withContentID";
					ad.contentID = "765532";
				}

                var adHTML
                    = "<a href=\"openPage:{&quot;pageID&quot;:&quot;" + ad.contentID
                    +"&quot;,&quot;pageURL&quot;:&quot;" + ad.contentURL
                    + "&quot;, &quot;openMethod&quot;:&quot;" + openMethod
                    + "&quot;,&quot;" + adId + "&quot;:&quot;" + ad.id + "&quot;}\" "
                    + "onclick=\"gsOnAdClick('" + ad.id + "');\">"
                    + "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
                    + "<tr>"
                    + "<td rowspan=\"2\" class=\"Icon\">"
                    + "<img src=\"" + ad.iconURL + "\" width=\"58\" height=\"58\">"
                    + "</td>"
                    + "<td class=\"Title\">" + ad.title + "</td>"
                    + "<td class=\"Badge\">"
                    + "<div>推广</div>"
                    + "</td>"
                    + "</tr>"
                    + "<tr>"
                    + "<td colspan=\"2\" class=\"Subtitle\">" + ad.subtitle + "</td>"
                    + "</tr>"
                    + "</tbody></table>"
                    + "</a>";

                var ad1 = document.getElementById("gsTemplateContent_AD1");
                if (ad1!=null)
                {
                    ad1.innerHTML = adHTML;
                    ad1.style.display = "block";
                }
            }
            catch (err)
            {
            }
        }break;
        case "gsTemplateContent_AD2":
        {
            var ad = param.value;

            if (typeof(ad.contentType)=="undefined")
            {
                // 1, 使用 contentURL
                // 2, 使用 contentID
                ad.contentType = 1;
            }
            if (typeof(ad.url)!="undefined")
            {
                ad.contentURL = ad.url;
            }

            var openMethod = "withContentID";
            if (ad.contentType=="1")
            {
                openMethod = "withContentURL";
            }
            else if (ad.contentType=="2")
            {
                openMethod = "withContentID";
            }
            else
            {
                openMethod = "default";
            }

            var adWidth = "100%";
            if (gsIsCurrentOSAndroid())
            {
                adWidth= document.body.clientWidth - 22;
            }

            var adId = "adId";
            if (gsIsCurrentOSAndroid())
            {
                adId = "adID";
            }
			
				if (ad.id==628)
				{
					ad.contentType = "withContentID";
					ad.contentID = "765526";
				}
				else if (ad.id==629)
				{
					ad.contentType = "withContentID";
					ad.contentID = "765532";
				}

            var adHTML
                = "<a href=\"openPage:{&quot;pageID&quot;:&quot;" + ad.contentID
                + "&quot;,&quot;pageURL&quot;:&quot;" + ad.contentURL
                + "&quot;, &quot;openMethod&quot;:&quot;" + openMethod
                + "&quot;,&quot;" + adId + "&quot;:&quot;" + ad.id + "&quot;}\" "
                + "onclick=\"gsOnAdClick('" + ad.id + "');\">"
                + "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
                + "<tr>"
                + "<td class=\"Icon\" colspan=\"2\">"
                + "<img src=\"" + ad.iconURL + "\">"
                + "</td>"
                + "</tr>"
                + "<tr>"
                + "<td class=\"Badge\" valign=\"top\">"
                + "<div>推广</div>"
                + "</td>"
                + "<td class=\"Title\">"
                + ad.title
                + "</td>"
                + "</tr>"
                + "</table>"
                + "</a>";

            var ad2 = document.getElementById("gsTemplateContent_AD2");
            if (ad2!=null)
            {
                ad2.innerHTML = adHTML;
                ad2.style.display = "block";
            }
        }break;
    }
}
function gsSetElementParamWithGSElementID(gsElementID, param)
{
    var gsElement = gsGetTheGSElementWithGSElementID(gsElementID);
    if (gsElement==null)
    {
        return;
    }

    switch (gsElement.tagName.toLowerCase())
    {
        case "img":
        {
            return gsSetTheImgElementParam(gsElement, param);
        }break;
        case "":
        default:
        {
            return gsSetPageParam(param);
        }break;
    }
    return "unknow";
}
function gsAddTouchEventListenerToObject(obj)
{
    if (obj==null
        || obj==undefined
        || obj.addEventListener==undefined)
    {
        return;
    }

    obj.addEventListener("touchstart", function(event)
    {
        gsSetElementClass(this, "", "TouchStart");
    }, false);
    obj.addEventListener("touchmove", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, false);

    obj.addEventListener("touchmove", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, true);
    obj.addEventListener("touchend", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, false);

    obj.addEventListener("touchend", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, true);

    obj.addEventListener("touchcancel", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, false);
    obj.addEventListener("touchcancel", function(event)
    {
        gsSetElementClass(this, "TouchStart", "");
    }, true);
}
function gsImageOnClick(img)
{
    if (img==null)
    {
        return;
    }
    var gsElementID = img.getAttribute("gsElementID");
    if (gsElementID==null
        || gsElementID.length<1)
    {
        return;
    }

    var indexInSet = -1;
    var setIndex = -1;
    var setImagesCount = 0;
    if (_kGSImgSetInfes!=null
        && _kGSImgSetInfes.length>0
        && gsIsElementClass(img.parentNode, "ImgBoxer"))
    //&& gsIsElementClass(img.parentNode, "ImgSetBoxer"))
    {
        var imgBoxer = img.parentNode;

        setIndex = imgBoxer.getAttribute("imgSetIndex");

        if (setIndex!=null
            && setIndex>=0
            && setIndex<_kGSImgSetInfes.length)
        {
            imgSetInfo = _kGSImgSetInfes[setIndex];

            indexInSet = imgBoxer.getAttribute("indexInImgSet");
            setImagesCount = imgSetInfo.imgBoxers.length;
        }
        else
        {
            indexInSet = -1;
            setIndex = -1;
            setImagesCount = 0;
        }
    }

    var documentLocation
        = "openImage:{"
        + "\"gsElementID\":\"" + gsElementID + "\""
        + ", "
        + "\"indexInSet\":" + indexInSet
        + ", "
        + "\"setIndex\":" + setIndex
        + ", "
        + "\"setImagesCount\":" + setImagesCount
        + ", "
        + "\"left\":" + img.offsetLeft
        + ", "
        + "\"top\":" + img.offsetTop
        + ", "
        + "\"width\":" + img.scrollWidth
        + ", "
        + "\"height\":" + img.scrollHeight
        + "}";
    gsSendMessageToSuperWebView(documentLocation);
}
function gsImageBoxerOnClick()
{
    var imgs
        = this.getElementsByTagName("IMG");
    if (imgs == null
        || imgs.length < 1)
    {
        return;
    }

    var img = imgs[0];
    gsImageOnClick(img);
}
function gsImageBoxerImgSetLogoOnClick()
{
    var imgSetImgBoxer = gsGetObjectParentWithClass(this, "ImgBoxer");
    if (imgSetImgBoxer==null)
    {
        return;
    }

    var imgSetIndex
        = imgSetImgBoxer.getAttribute("imgSetIndex");
    if (imgSetIndex == null)
    {
        imgSetIndex = -1;
    }
    else
    {
        imgSetIndex = parseInt(imgSetIndex);
    }

    if (_kGSImgSetInfes != null
        && imgSetIndex >= 0
        && imgSetIndex < _kGSImgSetInfes.length)
    {
        var imgSetInfo = _kGSImgSetInfes[imgSetIndex];

        // 标记转化为非图集
        imgSetInfo.setType = _kGSImgSetType_Unset;

        // 取消当前图集封皮
        gsSetTheImgSetCoverImgBoxer(imgSetInfo, -1);

        // 将隐藏的图集都展示出来
        var imgBoxers = imgSetInfo.imgBoxers;
        if (imgBoxers!=null
            && imgBoxers.length>0)
        {
            var imgBoxersCount = imgBoxers.length;
            for (var imgBoxerIndex=0;
                 imgBoxerIndex<imgBoxersCount;
                 imgBoxerIndex++)
            {
                var imgBoxer = imgBoxers[imgBoxerIndex];
                var imgBoxerParentPTag = gsGetObjectParentWithTag(imgBoxer, "P");
                if (imgBoxerParentPTag!=null)
                {
                    imgBoxerParentPTag.style.display
                        = "inline-block";
                }
            }
        }
    }

    // 请求当前图片
    gsOnWindowScroll();

    // 告知App用户展开了一次图集
    if (gsIsCurrentOSIOS()
        && kAppVersion!=null
        && typeof(kAppVersion)!="undefined"
        && kAppVersion.indexOf("2.1")==0)
    {
        var msg = "imgSetExpanded:{}"
        gsSendMessageToSuperWebView(msg);
    }

    event.stopPropagation();
    return false;
}
var _gsAutoLoadGSElementsEnable = true;
function gsSetAutoLoadGSElementsEnable(enbale)
{
    _gsAutoLoadGSElementsEnable = enbale;
}
function gsGetAutoLoadGSElementsEnable()
{
    return _gsAutoLoadGSElementsEnable;
}
function gsLoadTheGSElementWithID(gsElementID)
{
    var msg = "loadGSElements:{\"validElementIDs\":[\""
        + gsElementID
        + "\"], \"invalidElementIDs\":[]}"
    gsSendMessageToSuperWebView(msg);
}
function gsOnWindowScroll()
{
    if (_kGSIsNullImageModeBuffer==true)
    {
        return;
    }

    if (_gsAutoLoadGSElementsEnable!=true)
    {
        return;
    }

    var msg = "loadGSElements:"+gsGetGSElementsInCurrentViewArea();
    gsSendMessageToSuperWebView(msg);
}
function gsOnPageLoad()
{
    try
    {
        gsOnDocumentReadystatechange();
    }
    catch (exception)
    {
    }
}
var _kGSHadDocumentReady = false;
var _kGSDocumentImgSetNo = false;
if (typeof(kNotUseImgSet)!="undefined"
    && kNotUseImgSet==true)
{
    _kGSDocumentImgSetNo = true;
}
var _kGSDocumentImgSetMinImgsCount = 3;
function gsOnDocumentReadystatechange()
{
    if (_kGSHadDocumentReady)
    {
        return;
    }
    _kGSHadDocumentReady = true;

    var mainBody = document.getElementById("gsTemplateContent_MainBody");

    var appTags = mainBody.getElementsByTagName("app");
    if (appTags != null
        && appTags.length > 0)
    {
        for (var appTagIndex = appTags.length - 1;
             appTagIndex > -1;
             appTagIndex--)
        {
            var appTag = appTags[appTagIndex];
            if (appTag.getAttribute("非图集") != null)
            {
                _kGSDocumentImgSetNo = true;
            }

            var appImgSetMinImgsCount
                = appTag.getAttribute("图集最少图片数");
            if (appImgSetMinImgsCount != null)
            {
                appImgSetMinImgsCount = parseInt(appImgSetMinImgsCount);
                if (appImgSetMinImgsCount > 0)
                {
                    _kGSDocumentImgSetMinImgsCount = appImgSetMinImgsCount;
                }
            }
        }
    }

    // 首先卸载不需要的资源
    var unloadGSElementsIDsJSON = "";
    if (gsIsCurrentOSIOS())
    {
        var gsTemplateImageLoadersElements = document.getElementsByClassName("GSTemplateImageLoader");
        if (gsTemplateImageLoadersElements != null
            && gsTemplateImageLoadersElements.length > 0)
        {
            for (var gsTemplateImageLoaderElementIndex = 0;
                 gsTemplateImageLoaderElementIndex < gsTemplateImageLoadersElements.length;
                 gsTemplateImageLoaderElementIndex++)
            {
                var gsTemplateImageLoaderElement = gsTemplateImageLoadersElements[gsTemplateImageLoaderElementIndex];
                if (gsTemplateImageLoaderElement != null)
                {
                    var gsTemplateImageLoaderElementGSID = gsTemplateImageLoaderElement.getAttribute("gsElementID");
                    if (gsTemplateImageLoaderElementGSID != null
                        && gsTemplateImageLoaderElementGSID.length > 0)
                    {
                        unloadGSElementsIDsJSON += "\"" + gsTemplateImageLoaderElementGSID + "\",";
                    }
                }
            }
        }

        var adNoneElements = document.getElementsByClassName("adnone");
        if (adNoneElements != null
            && adNoneElements.length > 0)
        {
            for (var adNoneElementIndex = 0;
                 adNoneElementIndex < adNoneElements.length;
                 adNoneElementIndex++)
            {
                var adNoneElement = adNoneElements[adNoneElementIndex];
                var adNoneImages = adNoneElement.getElementsByTagName("img");
                if (adNoneImages != null && adNoneImages.length > 0)
                {
                    var adNoneImagesCount = adNoneImages.length;
                    for (var adNoneImageIndex = 0;
                         adNoneImageIndex < adNoneImagesCount;
                         adNoneImageIndex++)
                    {
                        var adNoneImage = adNoneImages[adNoneImageIndex];
                        var adNoneImageGSID = adNoneImage.getAttribute("gsElementID");
                        if (adNoneImageGSID != null
                            || adNoneImageGSID.length > 0)
                        {
                            unloadGSElementsIDsJSON += "\"" + adNoneImageGSID + "\",";
                        }
                    }
                }
                if (adNoneElement.parentNode != null)
                {
                    adNoneElement.parentNode.removeChild(adNoneElement);
                    adNoneElementIndex--;
                }
            }
        }
    }
    else if (gsIsCurrentOSAndroid())
    {
        loadImageInit();
    }

    if (unloadGSElementsIDsJSON != null
        && unloadGSElementsIDsJSON.length > 0)
    {
        unloadGSElementsIDsJSON = unloadGSElementsIDsJSON.substring(0, unloadGSElementsIDsJSON.length - 1);
        unloadGSElementsIDsJSON = "[" + unloadGSElementsIDsJSON + "]";
        var msg = "unloadGSElements:{\"unloadElementIDs\":" + unloadGSElementsIDsJSON + "}";
        gsSendMessageToSuperWebView(msg);
    }

    // 调整过滤超链接
    var mainBody = document.getElementById("gsTemplateContent_MainBody");

    var aTags = mainBody.getElementsByTagName("a");
    try
    {
        if (aTags != null
            && aTags.length > 0)
        {
            for (var aTagIndex = aTags.length - 1;
                 aTagIndex > -1;
                 aTagIndex--)
            {
                var aTag = aTags[aTagIndex];
                var aTagHref = aTag.getAttribute("href");

                var urlCheckResult = gsCheckTheURL(aTagHref, aTag);

                if (urlCheckResult.imgTag != null
                    && urlCheckResult.imgHDURL != null)
                {
                    urlCheckResult.imgTag.setAttribute("hdImageURL", urlCheckResult.imgHDURL);
                }

                if (urlCheckResult.valid == false
                    && aTag.parentNode != null)
                {
                    var aTagParentNode = aTag.parentNode;
                    var aTagChildNodes = aTag.childNodes;

                    if (aTag.textContent != "查看作者更多文章"
                        && aTagChildNodes != null
                        && aTagChildNodes.length > 0)
                    {
                        for (var aTagChildNodeIndex = 0;
                             aTagChildNodeIndex < aTagChildNodes.length;
                             aTagChildNodeIndex++)
                        {
                            aTagParentNode.insertBefore(aTagChildNodes[aTagChildNodeIndex], aTag);
                        }
                    }

                    aTagParentNode.removeChild(aTag);
                }
            }
        }
    }
    catch (err)
    {
    }

    // 准备图片操作
    var imgs = mainBody.getElementsByTagName("img");
    var imgsCount = imgs.length;
    var lastImgIndex = imgsCount - 1;

    // 为图片元素设置 Boxer
    var imgBoxers = new Array();
    var nullImageMode = _kGSIsNullImageModeBuffer;
    var bodyWidth = parseInt(document.getElementById("body").clientWidth);
    for (var imgIndex = 0;
         imgIndex < imgsCount;
         imgIndex++)
    {
        var originImg = imgs[imgIndex];
        var imgParentNode = originImg.parentNode;

        var imgBoxer = document.createElement("div");
        {
            imgBoxer.className = "ImgBoxer";
            if (nullImageMode)
            {
                gsSetTheImgBoxerBgType(imgBoxer, "nullImageMode", null);
            }
            else
            {
                gsSetTheImgBoxerBgType(imgBoxer, "progress", "0");
            }

            // 图集特殊属性设置
            // 图集封皮
            if (originImg.getAttribute("图集封皮") != null)
            {
                imgBoxer.setAttribute("imgSetCover", "yes");
            }
            // 不使用图集
            if (originImg.getAttribute("非图集") != null)
            {
                imgBoxer.setAttribute("imgSetNo", "yes");
            }

            var newImg = originImg.cloneNode();
            {
                newImg.onload = gsOnImageLoad;
            }
            imgBoxer.appendChild(newImg);


            newImg.style.display = "inline";
            var newImgSrc = gsGetTheImgSrc(newImg);
            if (newImgSrc == null
                || newImgSrc.length < 1
                || nullImageMode)
            {
                newImg.style.visibility = "hidden";
                imgBoxer.style.width = bodyWidth + "px";
                var imgBoxerHeight = bodyWidth * 0.618;
                imgBoxer.style.height = imgBoxerHeight + "px";
            }
            else
            {
                newImg.style.visibility = "visible";
            }

            var needGIFBadge = gsIsTheImgGIFAnimationThumbnail(newImg)
                && (_kGSIsCurrentAppNullImageProgressVersion || _kGSIsGIFImageNeedBadge);
            if (needGIFBadge)
            {
                var imgBoxerStatusBar = document.createElement("div");
                {
                    imgBoxerStatusBar.className = "ImgBoxerStatusBar";

                    var gifLogo = document.createElement("div");
                    gifLogo.className = "GIFLogo";
                    imgBoxerStatusBar.appendChild(gifLogo);

                    imgBoxerStatusBar.style.visibility = newImg.style.visibility;
                }
                newImg.parentNode.insertBefore(imgBoxerStatusBar, newImg.nextSibling);
            }
        }
        imgParentNode.replaceChild(imgBoxer, originImg);
        imgBoxers.push(imgBoxer);
    }

    // 进行图集分组
    try
    {
        // @图集-标记
        // 记录图集内容
        var imgBoxersInImgSet = new Array();
        var imgBoxersCount = imgBoxers.length;
        for (var imgBoxerIndex = 0;
             imgBoxerIndex < imgBoxersCount;
             imgBoxerIndex++)
        {
            var imgBoxer = imgBoxers[imgBoxerIndex];
            var nextImgBoxerIndex = imgBoxerIndex + 1;
            var nextImgBoxer = null;
            if (nextImgBoxerIndex<imgBoxersCount)
            {
                nextImgBoxer = imgBoxers[nextImgBoxerIndex];
            }

            if (nextImgBoxer!=null
                && gsIsObjectsContinuous(imgBoxer, nextImgBoxer))
            {
                if (imgBoxersInImgSet.length < 1)
                {
                    imgBoxersInImgSet.push(imgBoxer);
                    imgBoxersInImgSet.push(nextImgBoxer);
                }
                else
                {
                    imgBoxersInImgSet.push(nextImgBoxer);
                }
            }
            else
            {
                if (imgBoxersInImgSet.length > _kGSDocumentImgSetMinImgsCount)
                {
                    gsAddAImgSetInfoWithOriginImgBoxers(_kGSImgSetType_Set, imgBoxersInImgSet, imgBoxers);
                }
                imgBoxersInImgSet = new Array();
            }
        }
        if (imgBoxersInImgSet.length > _kGSDocumentImgSetMinImgsCount)
        {
            gsAddAImgSetInfoWithOriginImgBoxers(_kGSImgSetType_Set, imgBoxersInImgSet, imgBoxers);
        }
        else
        {
            gsAddAImgSetInfoWithOriginImgBoxers(_kGSImgSetType_Set, null, imgBoxers);
        }
        imgBoxersInImgSet = null;
    }
    catch (e)
    {
    }

    // 为图集添加Boxer
    if (_kGSImgSetInfes != null
        && _kGSImgSetInfes.length > 0)
    {
        for (var imgSetInfoIndex in _kGSImgSetInfes)
        {
            var imgSetInfo = _kGSImgSetInfes[imgSetInfoIndex];
            if (imgSetInfo.setType == _kGSImgSetType_Set)
            {
                gsSetTheImgSetCoverImgBoxer(imgSetInfo, imgSetInfo.defaultCoverImgBoxerIndex);
            }
        }
    }

    // 通知,设置视频信息
    if (_kGSVideoOriginContents != null
        && _kGSVideoOriginContents.length > 0)
    {
        var videoOriginContentsInfo = "{\"videoOriginContents\":[";

        var videoOriginContentsCount = _kGSVideoOriginContents.length;
        for (var videoOriginContentIndex = 0;
             videoOriginContentIndex < videoOriginContentsCount;
             videoOriginContentIndex++)
        {
            var videoOriginContent = _kGSVideoOriginContents[videoOriginContentIndex];
            if (videoOriginContent == null)
            {
                videoOriginContent = "";
            }
            videoOriginContent = videoOriginContent.replaceAll("\"", "\\\"");
            videoOriginContent = videoOriginContent.replaceAll("\r", "");
            videoOriginContent = videoOriginContent.replaceAll("\n", "");

            videoOriginContentsInfo += "\"" + videoOriginContent + "\"";
            if (videoOriginContentIndex + 1 < videoOriginContentsCount)
            {
                videoOriginContentsInfo += ", ";
            }
        }

        videoOriginContentsInfo += "]}";

        var msg = "GSApp://loadVideos?" + videoOriginContentsInfo;
        gsSendMessageToSuperWebView(msg);
    }

    // @tmp, 临时操作, 显示默认隐藏的评测幻灯内容.
    var slides = document.getElementsByClassName("Slides");
    if (slides!=null && slides.length>0)
    {
        var slidesCount = slides.length;
        for (var slideIndex=0;
             slideIndex<slidesCount;
             slideIndex++)
        {
            var slide = slides[slideIndex];
            var slideLies = slide.getElementsByTagName("LI");
            var slideLiesCount = slideLies.length;
            for (var slideLiIndex=0;
                 slideLiIndex<slideLiesCount;
                 slideLiIndex++)
            {
                var slideLi = slideLies[slideLiIndex];
                slideLi.style.display = "inline";

                try
                {
                    var br = document.createElement("BR");
                    slideLi.parentNode.insertBefore(br, slideLi.nextSibling);
                }
                catch (e)
                {}
            }
        }
    }

    // 加载"第一屏"的资源
    //gsOnWindowScroll();
    setTimeout(gsOnWindowScroll, 100);
}
function gsAdjustIMGBoxerOfTheIMG(img)
{
    var parentImgBoxer = null;
    if (!gsIsElementClass(img.parentNode, "ImgBoxer"))
    {
        return;
    }
    parentImgBoxer = img.parentNode;

    var imgWidthHadSpecified = false;
    var imgWidth = img.naturalWidth;
    if (img.scrollWidth>0)
    {
        imgWidthHadSpecified = true;
        imgWidth = img.scrollWidth;
    }
    else if (img.style.width.length>0)
    {
        imgWidthHadSpecified = true;
        imgWidth = parseInt(img.style.width);
    }
    else
    {
        var imgWidthAttribute = img.getAttribute("width");
        if (imgWidthAttribute!=null)
        {
            imgWidthHadSpecified = true;
            imgWidth = parseInt(imgWidthAttribute);
        }
    }

    var imgHeightHadSpecified = false;
    var imgHeight = img.naturalHeight;
    if (img.scrollHeight>0)
    {
        imgHeightHadSpecified = true;
        imgHeight = img.scrollHeight;
    }
    else if (img.style.height>0)
    {
        imgHeightHadSpecified = true;
        imgHeight = parseInt(img.style.height);
    }
    else
    {
        var imgHeightAttribute = img.getAttribute("height");
        if (imgHeightAttribute!=null)
        {
            imgHeightHadSpecified = true;
            imgHeight = parseInt(imgHeightAttribute);
        }
    }

    var isImgSetCover
        = gsIsElementClass(parentImgBoxer, "ImgSetBoxer");
    var imgBoxerMaxWidth
        = document.body.clientWidth - 20.0;
    if (isImgSetCover)
    {
        imgBoxerMaxWidth -= 10.0;
        /*
         var newImgWidth = imgWidth-10.0;
         if (imgWidth>0.0)
         {
         imgHeight
         = newImgWidth
         * imgHeight
         / imgWidth;
         }
         else
         {
         imgHeight
         = newImgWidth
         * 0.618;
         }
         imgWidth = newImgWidth;
         */
    }


    var isTooBigImg = false;
    if (imgWidth>imgBoxerMaxWidth)
    {
        isTooBigImg = true;
    }
    else if (imgWidthHadSpecified==false)
    {
        isTooBigImg
            = gsIsTheImgGIFAnimationThumbnail(img) || imgWidth>200;
    }


    var imgBoxerWidth = "100%";
    var imgBoxerHeight = "auto";
    if (isTooBigImg)
    {
        imgBoxerWidth = imgBoxerMaxWidth+"px";
        imgBoxerHeight = "auto";
    }
    else
    {
        imgBoxerWidth = imgWidth+"px";
        imgBoxerHeight = imgHeight+"px";
    }
    // 这里为img再次设置width,是了防止某些在表格等元素中的图片不能够撑起容器
    img.style.width = imgBoxerWidth;
    img.style.height = imgBoxerHeight;
    parentImgBoxer.style.width = imgBoxerWidth;
    parentImgBoxer.style.height = imgBoxerHeight;
    if (isImgSetCover)
    {
        for (var whitePageImgBoxer = parentImgBoxer.previousSibling;
             whitePageImgBoxer != null && gsIsElementClass(whitePageImgBoxer, "ImgSetWhitePage");
             whitePageImgBoxer = whitePageImgBoxer.previousSibling)
        {
            whitePageImgBoxer.style.marginBottom = (-1 * parseInt(imgBoxerHeight) - 2) + "px";
            whitePageImgBoxer.style.width = imgBoxerWidth;
            whitePageImgBoxer.style.height = imgBoxerHeight;
        }
    }

    /*
     // 无图模式只有一种处理方法
     if (_kGSIsNullImageModeBuffer==true)
     {
     gsSetTheImgBoxerBgType(parentImgBoxer, "nullImageMode", null);
     }
     // 有图模式根据图片状态进行处理
     else
     */
    {
        var imgSrc = gsGetTheImgSrc(img);

        var isImgValid = false;
        if (gsIsCurrentOSIOS())
        {
            isImgValid
                = imgSrc!=null
                && imgSrc.length>0
                && img.style.visibility=="visible";
        }
        else
        {
            isImgValid
                = imgSrc!=null
                && imgSrc.length>0;
        }

        if (isImgValid==true)
        {
            img.style.visibility = "visible";// 安卓特殊处理
            gsSetTheImgBoxerBgType(parentImgBoxer, "none", null);

            if (img.nextSibling!=null
                && gsIsElementClass(img.nextSibling, "ImgBoxerStatusBar"))
            {
                img.nextSibling.style.visibility = "visible";
            }
        }
        // 图片等待加载
        else
        {
            if (_kGSIsNullImageModeBuffer == true)
            {
                gsSetTheImgBoxerBgType(parentImgBoxer, "nullImageMode", null);
            }
            else
            {
                gsSetTheImgBoxerBgType(parentImgBoxer, "progress", "0");
            }
        }
    }
}

var _kGSImgSetInfes = new Array();
// setType:
// "unknow", 未知类型.
// "set", 普通图集.
// "unset", 非图集普通图片的集合信息.
var _kGSImgSetType_Unknow = "unknow";
var _kGSImgSetType_Set = "set";
var _kGSImgSetType_Unset = "unset";
function gsAddAImgSetInfoWithOriginImgBoxers(imgSetType, originImgBoxersInImgSet, allImgBoxers)
{
    var isImgSetType = imgSetType==_kGSImgSetType_Set;
    if (isImgSetType)
    {
        // 检查是否之前有非图集内容
        // 如果存在非图集内容
        // 则先加入非图集内容
        if (allImgBoxers!=null
            && allImgBoxers.length>0)
        {
            var firstImgBoxerIndex = -1;
            if (originImgBoxersInImgSet!=null
                && originImgBoxersInImgSet.length>0)
            {
                var firstImgBoxerInImgSet = originImgBoxersInImgSet[0];
                var allImgBoxersCount = allImgBoxers.length;
                for (var imgBoxerIndex = 0;
                     imgBoxerIndex < allImgBoxersCount;
                     imgBoxerIndex++)
                {
                    var imgBoxer = allImgBoxers[imgBoxerIndex];
                    if (imgBoxer == firstImgBoxerInImgSet)
                    {
                        firstImgBoxerIndex = imgBoxerIndex;
                        break;
                    }
                }
            }
            else
            {
                firstImgBoxerIndex = allImgBoxers.length;
            }

            if (firstImgBoxerIndex!=-1)
            {
                var imgBoxersInUnImgSet = new Array();
                for (var imgBoxerIndex=firstImgBoxerIndex-1;
                     imgBoxerIndex>-1;
                     imgBoxerIndex--)
                {
                    var imgBoxer = allImgBoxers[imgBoxerIndex];
                    if (imgBoxer.getAttribute("imgSetIndex")==null)
                    {
                        imgBoxersInUnImgSet.push(imgBoxer);
                    }
                    else
                    {
                        break;
                    }
                }
                if (imgBoxersInUnImgSet!=null
                    && imgBoxersInUnImgSet.length>0)
                {
                    imgBoxersInUnImgSet = imgBoxersInUnImgSet.reverse();
                    var imgBoxersCountInUnImgSet = imgBoxersInUnImgSet.length;
                    for (var imgBoxerIndexInUnImgSet=0;
                         imgBoxerIndexInUnImgSet<imgBoxersCountInUnImgSet;
                         imgBoxerIndexInUnImgSet++)
                    {
                        var unImgSet = new Array();
                        var lastImgBoxerPTag = null;
                        for (;
                            imgBoxerIndexInUnImgSet<imgBoxersCountInUnImgSet;)
                        {
                            var imgBoxer = imgBoxersInUnImgSet[imgBoxerIndexInUnImgSet];

                            var isValidImgBoxer = false;
                            var imgBoxerPTag = gsGetObjectParentWithTag(imgBoxer, "P");
                            {
                                if (lastImgBoxerPTag == null)
                                {
                                    isValidImgBoxer = true;
                                }
                                else
                                {
                                    if (lastImgBoxerPTag.nextElementSibling == imgBoxerPTag)
                                    {
                                        isValidImgBoxer = true;
                                    }
                                }
                            }
                            lastImgBoxerPTag = imgBoxerPTag;

                            if (isValidImgBoxer)
                            {
                                unImgSet.push(imgBoxer);

                                imgBoxerIndexInUnImgSet++;
                            }
                            else
                            {
                                imgBoxerIndexInUnImgSet--;
                                break;
                            }
                        }
                        gsAddAImgSetInfoWithOriginImgBoxers(_kGSImgSetType_Unset, unImgSet, allImgBoxers);
                    }
                }
            }
        }

        if (originImgBoxersInImgSet==null
            || originImgBoxersInImgSet.length<1)
        {
            return -1;
        }

        if (_kGSDocumentImgSetNo==true)
        {
            return -1;
        }

        for (var imgBoxerIndex in originImgBoxersInImgSet)
        {
            var imgBoxer = originImgBoxersInImgSet[imgBoxerIndex];
            if (imgBoxer.getAttribute("imgSetNo") == "yes")
            {
                return -1;
            }
        }
    }

    // 更新图集图片信息
    var imgSetIndex = _kGSImgSetInfes.length;
    var className_ImgSetIndex = "ImgInSet_" + imgSetIndex;
    var defaultCoverImgBoxerIndex = 0;
    for (var imgBoxerIndex in originImgBoxersInImgSet)
    {
        var imgBoxer = originImgBoxersInImgSet[imgBoxerIndex];

        var className_ImgIndexWithSetIndex
            = className_ImgSetIndex
            + "_" + imgBoxerIndex;

        imgBoxer.setAttribute("imgSetIndex", imgSetIndex);
        imgBoxer.setAttribute("indexInImgSet", imgBoxerIndex);
        imgBoxer.className
            += " " + className_ImgSetIndex
            + " "
            + className_ImgIndexWithSetIndex;

        // 设置相关 img 标签
        var childImgs
            = imgBoxer.getElementsByTagName("IMG");
        if (childImgs!=null
            && childImgs.length>0)
        {
            var img = childImgs[0];
            img.className
                += " " + className_ImgSetIndex
                + " "
                + className_ImgIndexWithSetIndex;
        }

        // 图集类型的相关设置
        if (isImgSetType)
        {
            var imgBoxerImgSetCover = imgBoxer.getAttribute("imgSetCover");
            if (imgBoxerImgSetCover == "yes")
            {
                defaultCoverImgBoxerIndex = imgBoxerIndex;
            }

            // 设置父级别 P 标签
            var imgBoxerParentPTag
                = gsGetObjectParentWithTag(imgBoxer, "P");
            if (imgBoxerParentPTag != null)
            {
                imgBoxerParentPTag.style.display = "none";
            }
        }
    }

    // 增加图集信息
    var newImgSetInfo = new Object();
    {
        // setType: "set",普通图集; "unset",非图集普通图片的集合信息.
        newImgSetInfo.setType = imgSetType;
        newImgSetInfo.defaultCoverImgBoxerIndex = defaultCoverImgBoxerIndex;
        newImgSetInfo.coverImgBoxer = null;
        newImgSetInfo.imgBoxers = originImgBoxersInImgSet;
    }
    _kGSImgSetInfes.push(newImgSetInfo);

    return _kGSImgSetInfes.length;
}
function gsSetTheImgSetCoverImgBoxer(imgSetInfo, coverImgBoxerIndex)
{
    try
    {
        if (imgSetInfo == null
            || imgSetInfo.imgBoxers == null)
        {
            return;
        }

        var standardImgBoxerWidth
            = document.body.clientWidth - 20.0;

        // 取消旧的 coverImgBoxer 样式
        if (imgSetInfo.coverImgBoxer != null
            && parseInt(imgSetInfo.coverImgBoxer.getAttribute("IndexInImgSet"))!=coverImgBoxerIndex)
        {
            var lastCoverImgBoxer = imgSetInfo.coverImgBoxer;

            var prevNode = lastCoverImgBoxer.previousSibling;
            if (prevNode != null
                && gsIsElementClass(prevNode, "ImgSetWhitePage"))
            {
                var imgSetWhitePage3 = prevNode;

                prevNode = imgSetWhitePage3.previousSibling;
                if (prevNode != null
                    && gsIsElementClass(prevNode, "ImgSetWhitePage"))
                {
                    var imgSetWhitePage2 = prevNode;

                    prevNode = imgSetWhitePage2.previousSibling;
                    if (prevNode != null
                        && gsIsElementClass(prevNode, "ImgSetWhitePage"))
                    {
                        var imgSetWhitePage1 = prevNode;

                        imgSetWhitePage1.parentNode.removeChild(imgSetWhitePage1);
                    }
                    imgSetWhitePage2.parentNode.removeChild(imgSetWhitePage2);
                }
                imgSetWhitePage3.parentNode.removeChild(imgSetWhitePage3);
            }

            var coverImgBoxerOriginWidth = parseFloat(lastCoverImgBoxer.style.width);
            var coverImgBoxerHeightWidthRate = 0.618;
            if (coverImgBoxerOriginWidth > 0.0)
            {
                coverImgBoxerHeightWidthRate
                    = parseFloat(lastCoverImgBoxer.style.height) / coverImgBoxerOriginWidth;
            }
            var coverImgBoxerWidth
                = parseFloat(standardImgBoxerWidth)+"px";
            var coverImgBoxerHeight
                = parseFloat(coverImgBoxerWidth * coverImgBoxerHeightWidthRate)+"px";

            // 设置 lastCoverImgBoxer的样式
            {
                gsSetElementClass(lastCoverImgBoxer, "ImgSetBoxer", "ImgBoxer");
                lastCoverImgBoxer.style.width
                    = coverImgBoxerWidth;
                lastCoverImgBoxer.style.height
                    = coverImgBoxerHeight;
                // 设置 lastCoverImgBoxer.img的样式
                var imgs = lastCoverImgBoxer.getElementsByTagName("IMG");
                if (imgs!=null
                    && imgs.length>0)
                {
                    var imgsCount = imgs.length;
                    for (var imgIndex=0;
                         imgIndex<imgsCount;
                         imgIndex++)
                    {
                        var img = imgs[imgIndex];
                        img.style.width
                            = coverImgBoxerWidth;
                        img.style.height
                            = coverImgBoxerHeight;
                    }
                }
            }

            // 删除 imgSetLogos
            var imgSetLogos
                = lastCoverImgBoxer.getElementsByClassName("ImgSetLogo");
            if (imgSetLogos != null
                && imgSetLogos.length > 0)
            {
                for (var imgSetLogoIndex = imgSetLogos.length - 1;
                     imgSetLogoIndex > -1;
                     imgSetLogoIndex--)
                {
                    var imgSetLogo = imgSetLogos[imgSetLogoIndex];
                    imgSetLogo.parentNode.removeChild(imgSetLogo);
                }
            }

            // 隐藏父P标签
            var imgBoxerParentNode
                = gsGetObjectParentWithTag(lastCoverImgBoxer, "P");
            imgBoxerParentNode.style.display = "none";
        }

        var coverImgBoxer = null;

        // 设置新的 coverImgBoxer 样式
        if (coverImgBoxerIndex >= 0
            && coverImgBoxerIndex < imgSetInfo.imgBoxers.length)
        {
            coverImgBoxer = imgSetInfo.imgBoxers[coverImgBoxerIndex];
            var coverImgBoxerParentPTag = gsGetObjectParentWithTag(coverImgBoxer, "P");
            if (coverImgBoxerParentPTag == null)
            {
                coverImgBoxer = null;
            }
        }


        if (coverImgBoxer==null
            || coverImgBoxer==imgSetInfo.coverImgBoxer)
        {
            return;
        }


        imgSetInfo.coverImgBoxer = coverImgBoxer;
        if (coverImgBoxer != null)
        {
            // 设置 ImgSetBoxer
            gsSetElementClass(coverImgBoxer, null, "ImgSetBoxer");

            var imgsInImgBoxer = coverImgBoxer.getElementsByTagName("IMG");
            var img = null;
            if (imgsInImgBoxer != null
                && imgsInImgBoxer.length > 0)
            {
                img = imgsInImgBoxer[0];
            }

            var coverImgBoxerHeightWidthRate = 0.618;
            var coverImgBoxerOriginWidth = parseFloat(coverImgBoxer.offsetHeight);
            if (isNaN(coverImgBoxerOriginWidth)
                || coverImgBoxerOriginWidth == 0.0)
            {
                coverImgBoxerOriginWidth = img.naturalWidth;
            }
            var coverImgBoxerOriginHeight = parseFloat(coverImgBoxer.offsetWidth);
            if (isNaN(coverImgBoxerOriginHeight)
                || coverImgBoxerOriginHeight == 0.0)
            {
                coverImgBoxerOriginHeight = img.naturalHeight;
            }
            if (isNaN(coverImgBoxerOriginWidth) == false
                && coverImgBoxerOriginWidth > 0.0
                && isNaN(coverImgBoxerOriginHeight) == false
                && coverImgBoxerOriginHeight > 0.0)
            {
                coverImgBoxerHeightWidthRate
                    = coverImgBoxerOriginHeight
                    / coverImgBoxerOriginWidth;
            }

            var coverImgBoxerWidth = parseFloat(standardImgBoxerWidth) - 10.0;
            var coverImgBoxerHeight = coverImgBoxerWidth * coverImgBoxerHeightWidthRate;

            coverImgBoxer.style.width
                = coverImgBoxerWidth.toString() + "px";
            coverImgBoxer.style.height
                = coverImgBoxerHeight.toString() + "px";

            // 添加 imgSetLogos
            {
                var imgBoxerStatusBar = null;
                var imgBoxerStatusBars
                    = coverImgBoxer.getElementsByClassName("ImgBoxerStatusBar");
                if (imgBoxerStatusBars != null
                    && imgBoxerStatusBars.length > 0)
                {
                    imgBoxerStatusBar = imgBoxerStatusBars[0];
                }
                else
                {
                    imgBoxerStatusBar = document.createElement("div");
                    {
                        imgBoxerStatusBar.className = "ImgBoxerStatusBar";

                        if (img != null)
                        {
                            if (coverImgBoxerIndex > 0
                                || img.naturalWidth > 0.0
                                || img.naturalHeight > 0.0)
                            {
                                imgBoxerStatusBar.style.visibility = "visible";
                            }
                            else
                            {
                                imgBoxerStatusBar.style.visibility = img.style.visibility;
                            }
                        }
                    }
                    coverImgBoxer.appendChild(imgBoxerStatusBar);
                }
                var imgSetLogo = document.createElement("div");
                {
                    imgSetLogo.className = "ImgSetLogo";

                    /*
                     var caption
                     = (parseInt(coverImgBoxerIndex) + 1).toString()
                     + "/"
                     + imgSetInfo.imgBoxers.length.toString();
                     var captionNode = document.createTextNode(caption);
                     imgSetLogo.appendChild(captionNode);
                     */

                    var imgSetLogoInnerHTML
                        = "<table align=\"center\" valign=\"top\" style=\"width: auto; height: 100%;\" cellpadding=\"0\" cellspacing=\"0\">"
                        + "<tr>"
                        + "<td class='Icon' width=\"44px\" valign=\"middle\" align=\"center\"></td>"
                        + "<td class=\"Caption\" width=\"auto\" align=\"left\">"
                        + "展开图集 (" + (parseInt(coverImgBoxerIndex) + 1).toString() + "/" + imgSetInfo.imgBoxers.length.toString() + ")"
                        + "</td>"
                        + "</tr>"
                        + "</table>";
                    imgSetLogo.innerHTML = imgSetLogoInnerHTML;
                    imgSetLogo.onclick = gsImageBoxerImgSetLogoOnClick;
                }
                imgBoxerStatusBar.appendChild(imgSetLogo);
            }


            // 添加 ImgSetWhitePages
            var imgBoxerWidth = coverImgBoxerWidth;
            var imgBoxerHeight = coverImgBoxerHeight;
            var imgSetWhitePageMarginBottom = (-1 * imgBoxerHeight - 2) + "px";
            var imgBoxerParentNode = coverImgBoxer.parentNode;


            var imgSetWhitePage1 = document.createElement("div");
            {
                imgSetWhitePage1.className = "ImgSetWhitePage";
                imgSetWhitePage1.style.width = imgBoxerWidth + "px";
                imgSetWhitePage1.style.height = imgBoxerHeight + "px";

                imgSetWhitePage1.style.marginBottom = imgSetWhitePageMarginBottom;
                imgSetWhitePage1.style.marginLeft = "8px";
                imgSetWhitePage1.style.marginTop = "10px";
            }
            imgBoxerParentNode.insertBefore(imgSetWhitePage1, coverImgBoxer);

            var imgSetWhitePage2 = document.createElement("div");
            {
                imgSetWhitePage2.className = "ImgSetWhitePage";
                imgSetWhitePage2.style.width = imgBoxerWidth + "px";
                imgSetWhitePage2.style.height = imgBoxerHeight + "px";

                imgSetWhitePage2.style.marginBottom = imgSetWhitePageMarginBottom;
                imgSetWhitePage2.style.marginLeft = "6px";
            }
            imgBoxerParentNode.insertBefore(imgSetWhitePage2, coverImgBoxer);

            var imgSetWhitePage3 = document.createElement("div");
            {
                imgSetWhitePage3.className = "ImgSetWhitePage";
                imgSetWhitePage3.style.width = imgBoxerWidth + "px";
                imgSetWhitePage3.style.height = imgBoxerHeight + "px";

                imgSetWhitePage3.style.marginBottom = imgSetWhitePageMarginBottom;
                imgSetWhitePage3.style.marginLeft = "4px";
            }
            imgBoxerParentNode.insertBefore(imgSetWhitePage3, coverImgBoxer);

            var imgBoxerParentPTag = null;
            if (imgBoxerParentNode.tagName=="P")
            {
                imgBoxerParentPTag = imgBoxerParentNode;
            }
            else
            {
                imgBoxerParentPTag = gsGetObjectParentWithTag(coverImgBoxer, "P");
            }
            imgBoxerParentPTag.style.display = "inline";
        }
    }
    catch (err)
    {
    }
}
function gsOnImageLoad()
{
    gsAdjustIMGBoxerOfTheIMG(this);
}
function gsOnAdClick(adId)
{
    /*
     if (adId == null
     || adId.length < 1
     || adId == "0")
     {
     return;
     }

     if (gsIsCurrentOSAndroid())
     {
     return;
     }

     if (!kAppVersion.indexOf("2.0.")
     && !kAppVersion.indexOf("2.1."))
     {
     return;
     }

     try
     {
     }
     catch (e)
     {}
     */
}
function gsReloadTheImgBoxerImage(imgBoxer)
{
    if (imgBoxer!=null
        && imgBoxer instanceof Event)
    {
        imgBoxer = event.target;
    }

    if (imgBoxer==null
        || !gsIsElementClass(imgBoxer, "ImgBoxer"))
    {
        return;
    }

    var imgsInImageBoxer
        = imgBoxer.getElementsByTagName("img");
    if (imgsInImageBoxer==null
        || imgsInImageBoxer.length<1)
    {
        return;
    }

    var img = imgsInImageBoxer[0];
    if (img==null)
    {
        return;
    }

    if (gsIsCurrentOSIOS())
    {
        var msg = "loadTheGSElement:"+img.getAttribute("gsElementID");
        gsSendMessageToSuperWebView(msg);
        gsSetTheImgBoxerBgType(imgBoxer, "progress", "0");
    }
    else if (gsIsCurrentOSAndroid())
    {
        /*...安卓...*/
        var url = img.getAttribute("ori_link");
        window.handler.loadImage(url);
        gsSetTheImgBoxerBgType(imgBoxer, "progress", "0");
    }
}
function gsReloadTheImgWithImgGSElementID(imgGSElementID)
{
    if (imgGSElementID==null
        || imgGSElementID.length<1)
    {
        return;
    }
    var img = gsGetTheGSElementWithGSElementID(imgGSElementID);
    if (img==null)
    {
        return;
    }
    if (gsIsElementClass(img.parentNode, "ImgBoxer"))
    {
        gsReloadTheImgBoxerImage(img.parentNode);
    }
}
/*视频相关方法*/
// 优酷视频Id结束符号
var _GSYouKuVideoIdEndSign = "==";
function gsGetYouKuVideoIdFromVideoContent(videoContent)
{
    // 尝试获取优酷视频Id.
    var youkuVideoId = null;
    if (videoContent!=null
        && videoContent.length>-1)
    {
        // 去除空格.
        videoContent = videoContent.replace(new RegExp(" ", "gm"), "");
        // 保存原始视频内容.
        var originVideoContent = videoContent;
        // 小写化.
        videoContent = videoContent.toLowerCase();

        // 尝试从URL格式的视频代码中获取视频Id.
        var urlPlayerSign
            = "http://v.youku.com/v_show/id_";
        var indexOfURLPlayerSign
            = videoContent.indexOf(urlPlayerSign);
        if (indexOfURLPlayerSign>-1)
        {
            var youkuVideoIdBeginCharIndex
                = indexOfURLPlayerSign + urlPlayerSign.length;
            var youkuVideoIdEndCharIndex
                = videoContent.indexOf(
                    _GSYouKuVideoIdEndSign,
                    youkuVideoIdBeginCharIndex)
                + _GSYouKuVideoIdEndSign.length;
            youkuVideoId
                = originVideoContent.substring(youkuVideoIdBeginCharIndex, youkuVideoIdEndCharIndex);
        }
        else
        {
            // 尝试从iFrame格式的视频代码中获取视频Id.
            var iFramePlayerSign
                = "http://player.youku.com/embed/";
            var indexOfiFramePlayerSign
                = videoContent.indexOf(iFramePlayerSign);
            if (indexOfiFramePlayerSign>-1)
            {
                var youkuVideoIdBeginCharIndex
                    = indexOfiFramePlayerSign + iFramePlayerSign.length;
                var youkuVideoIdEndCharIndex
                    = videoContent.indexOf(
                        _GSYouKuVideoIdEndSign,
                        youkuVideoIdBeginCharIndex)
                    + _GSYouKuVideoIdEndSign.length;
                youkuVideoId
                    = originVideoContent.substring(youkuVideoIdBeginCharIndex, youkuVideoIdEndCharIndex);
            }
            else
            {
                // 尝试从JS格式的视频代码中获取视频Id.
                var jsPlayerSign
                    = "vid:'";
                var indexOfJSPlayerSign
                    = videoContent.indexOf(jsPlayerSign);
                if (indexOfJSPlayerSign>-1)
                {
                    var youkuVideoIdBeginCharIndex
                        = indexOfJSPlayerSign + jsPlayerSign.length;
                    var youkuVideoIdEndCharIndex
                        = videoContent.indexOf(
                            _GSYouKuVideoIdEndSign,
                            youkuVideoIdBeginCharIndex)
                        + _GSYouKuVideoIdEndSign.length;
                    youkuVideoId
                        = originVideoContent.substring(youkuVideoIdBeginCharIndex,
                        youkuVideoIdEndCharIndex);
                }
            }
        }
    }
    return youkuVideoId;
}
var _kGSVideoOriginContents = new Array();
var _kGSVideoOriginContentTypeBeginSign_HTML = "html://";
var _kGSVideoOriginContentTypeBeginSign_URL = "url://";
var _kGSVideoOriginContentTypeBeginSign_YouKuVideoId = "youKuVideoId://";
function gsSaveAnVideoOriginContent(videoOriginContent)
{
    if (videoOriginContent==null
        || videoOriginContent.length<1)
    {
        return -1;
    }

    ////////////////////////////////////////////////
    // 过滤调整 videoOriginContent
    ////////////////////////////////////////////////
    var videoOriginContentBeginSign = _kGSVideoOriginContentTypeBeginSign_HTML;
    {
        videoOriginContent = videoOriginContent.trim();

        var indexOfIFrameTagBeginCharIndex = videoOriginContent.indexOfWithIgnorecase("<iframe");
        if (indexOfIFrameTagBeginCharIndex == 0)
        {
            var indexOfIFrameTagEndCharIndex = videoOriginContent.indexOf(">");
            if (indexOfIFrameTagEndCharIndex > -1)
            {
                var iFrameTag = videoOriginContent.substring(indexOfIFrameTagBeginCharIndex,
                    indexOfIFrameTagEndCharIndex + 1);
                if (iFrameTag != null && iFrameTag.length > 0)
                {
                    var srcBegin = "src=\"";
                    var indexOfSrcBeginCharIndex
                        = iFrameTag.indexOfWithIgnorecase(srcBegin);
                    if (indexOfSrcBeginCharIndex<0)
                    {
                        srcBegin = "src=\'";
                        indexOfSrcBeginCharIndex
                            = iFrameTag.indexOfWithIgnorecase(srcBegin);
                    }
                    if (indexOfSrcBeginCharIndex > 0)
                    {
                        iFrameTag = iFrameTag.substring(indexOfSrcBeginCharIndex + srcBegin.length);
                        indexOfSrcBeginCharIndex = 0;

                        var srcEndSign = srcBegin.charAt(srcBegin.length-1);

                        var indexOfSrcEndCharIndex = iFrameTag.indexOf(srcEndSign);
                        if (indexOfSrcEndCharIndex > 0)
                        {
                            var iFrameTagLength = iFrameTag.length;
                            while (indexOfSrcEndCharIndex > 0
                            && indexOfSrcEndCharIndex < iFrameTagLength
                            && iFrameTag.charAt(indexOfSrcEndCharIndex - 1) == "\\")
                            {
                                indexOfSrcEndCharIndex = iFrameTag.indexOf(srcEndSign, indexOfSrcEndCharIndex + 1);
                            }
                        }
                        if (indexOfSrcEndCharIndex < 0)
                        {
                            indexOfSrcEndCharIndex = iFrameTag.length;
                        }

                        iFrameTag = iFrameTag.substring(indexOfSrcBeginCharIndex,
                            indexOfSrcEndCharIndex - indexOfSrcBeginCharIndex);
                        ////////////////////////////////////////////////
                        // 调整后的 videoOriginContent
                        ////////////////////////////////////////////////
                        videoOriginContentBeginSign = _kGSVideoOriginContentTypeBeginSign_URL;
                        videoOriginContent = iFrameTag;
                    }
                }
            }
        }
    }

    videoOriginContent = videoOriginContentBeginSign + videoOriginContent;

    if (gsIsCurrentOSIOS()
        && _kGSAppVersionNumberCode>=221)
    {
        var youkuVideoId = gsGetYouKuVideoIdFromVideoContent(videoOriginContent);
        if (youkuVideoId != null
            && youkuVideoId.length > 0)
        {
            videoOriginContent
                = _kGSVideoOriginContentTypeBeginSign_YouKuVideoId
                + youkuVideoId
                + ","
                + videoOriginContent;
        }
    }


    ////////////////////////////////////////////////
    // 加入 kGSVideoOriginContents
    ////////////////////////////////////////////////
    if (_kGSVideoOriginContents==null)
    {
        _kGSVideoOriginContents = new Array();
    }
    _kGSVideoOriginContents.push(videoOriginContent);

    return _kGSVideoOriginContents.length-1;
}
function gsSetVideoPosterImgURLWithVideoIndex(videoIndex, posterImgURL)
{
    var videoPlayerBox = document.getElementById("videoBoxer_"+videoIndex);
    if (videoPlayerBox==null)
    {
        return;
    }

    if (posterImgURL.indexOf("url(")!=0)
    {
        posterImgURL = "url(" + posterImgURL + ")";
    }


    var videoPlayerBoxWidth = videoPlayerBox.clientWidth;
    var videoPlayerBoxHeight = videoPlayerBox.clientHeight;
    var videoPlayerBoxBackgroundSize
        = videoPlayerBoxWidth + "px " + videoPlayerBoxHeight + "px";


    videoPlayerBox.style.backgroundSize = videoPlayerBoxBackgroundSize;//"auto";
    videoPlayerBox.style.backgroundImage = posterImgURL;

    var videoPlayButtonBackgrounds
        = videoPlayerBox.getElementsByClassName("PlayButtonBackground");
    if (videoPlayButtonBackgrounds==null
        || videoPlayButtonBackgrounds.length<1)
    {
        return;
    }

    var videoPlayButtonBackgroundsCount = videoPlayButtonBackgrounds.length;
    for (var videoPlayButtonBackgroundIndex=0;
         videoPlayButtonBackgroundIndex<videoPlayButtonBackgroundsCount;
         videoPlayButtonBackgroundIndex++)
    {
        var videoPlayButtonBackground = videoPlayButtonBackgrounds[videoPlayButtonBackgroundIndex];

        videoPlayButtonBackground.style.backgroundSize = videoPlayerBoxBackgroundSize;//"auto";
        videoPlayButtonBackground.style.backgroundImage = posterImgURL;
    }
}
function gsPlayVideoWithVideoIndex(videoIndex)
{
    var videoPlayerBox = document.getElementById("videoBoxer_"+videoIndex);
    if (videoPlayerBox==null)
    {
        return;
    }

    /*
     var youkuVideoId = null;
     if (gsIsCurrentOSIOS()
     && _kGSAppVersionNumberCode<221
     && _kGSVideoOriginContents!=null
     && videoIndex>=0
     && videoIndex<_kGSVideoOriginContents.length)
     {
     var videoOriginContent = _kGSVideoOriginContents[videoIndex];
     youkuVideoId = gsGetYouKuVideoIdFromVideoContent(videoOriginContent);
     }
     if (youkuVideoId!=null
     && youkuVideoId.length>0)
     {
     gsOpenTheArticelWithURL("http://v.youku.com/v_show/id_" + youkuVideoId + ".html");
     }
     else
     */
    {
        var msg
            = "GSApp://playVideo?{"
            + "\"videoIndex\":" + videoIndex + ", "
            + "\"left\":" + videoPlayerBox.offsetLeft + ", "
            + "\"top\":" + videoPlayerBox.offsetTop + ", "
            + "\"width\":" + videoPlayerBox.scrollWidth + ", "
            + "\"height\":" + videoPlayerBox.scrollHeight
            + "}";

        gsSendMessageToSuperWebView(msg);
    }
}
function gsCreateLeTvVideoContent(videoId, videoParam)
{
    var bodyWidth = document.body.clientWidth-20.0;
    var height = bodyWidth*9.0/16.0;
    var width = bodyWidth;
    var leTv_videosupport_js = "http:\/\/j.gamersky.com\/wap\/js\/leTv_videosupport_2.0_v1.m.js";

    var html
        = "<div id=\"leshitvauto\" style=\"margin-left:auto;margin-right:auto; width:" + width + "; height:" + height + ";\">"

        + "<script type=\"text\/javascript\">"

        + "var domainname = \"http:\/\/yuntv.letv.com\/\";"

        + "<\/script>"
        + "<script type=\"text\/javascript\" src=\"http:\/\/yuntv.letv.com\/swfobj_1.3.m.js\"><\/script>"

        + "<script type=\"text\/javascript\" src=\"" + leTv_videosupport_js  + "\"><\/script>"

        + "<script type=\"text\/javascript\" src=\"http:\/\/yuntv.letv.com\/user_defined.js?v2\"><\/script>"

        + "<script type=\"text\/javascript\" src=\"http:\/\/yuntv.letv.com\/js\/player_v2.3.js\" data=\"{uu:'" + videoId + "',vu:'" + videoParam + "',auto_play:'0',gpcflag:'1',width:'" + width + "',height:'" + height + "'}\"><\/script>"

        + "<\/div>";

    return html;
}
/*初始化信息*/
if (gsIsCurrentOSIOS())
{
    /*关联事件*/
    window.onscroll = gsOnWindowScroll;
    if (_kGSIsImageNeedDocumentReadyEventVersion)
    {
        document.onreadystatechange = gsOnDocumentReadystatechange;
    }
}
else
{
    if (kAppVersion!="1.0.8")
    {
        // document.onreadystatechange = gsOnDocumentReadystatechange;
        window.onload = gsOnDocumentReadystatechange;
    }
}
if (typeof(kDefaultPageColorMode)!="undefined")
{
    gsSetPageParam({name:"pageColorMode", value:kDefaultPageColorMode});
}
if (typeof(kDefaultPageFontSize)!="undefined")
{
    gsSetPageParam({name:"pageFontSize", value:kDefaultPageFontSize});
}

////////////////////////////////////////////////
/* App和主站公用的JS代码 */
////////////////////////////////////////////////
function gsVideoInApp(videoType, videoContent, videoParam, videoWidth, videoHeight)
{
    switch (videoType)
    {
        case "优酷":
        case "土豆":
        {
            videoContent = videoContent;
        }break;
        case "乐视":
        {
            videoContent
                = gsCreateLeTvVideoContent(videoContent, videoParam);
        }break;
    }

    var videoHTML = videoContent;

    if ((gsIsCurrentOSIOS() && _kGSAppVersionNumberCode>=201)
        ||
        gsIsCurrentOSAndroid())
    {
        var videoIndex = gsSaveAnVideoOriginContent(videoContent);

        if (videoIndex>-1)
        {
            var videoDefaultWidth
                = document.body.clientWidth-20.0;
            var videoDefaultHeight
                = videoDefaultWidth
                * 1080.0/1920.0;

            videoHTML
                = "<table class=\"GSTemplateContent_VideoBoxer\" id=\"videoBoxer_" + videoIndex + "\" style=\"\" border=\"0\" width=\"" + videoDefaultWidth + "\" height=\"" + videoDefaultHeight + "\" cellspacing=\"0\" cellpadding=\"0\">"
                + "<tr>"
                + "<td valign=\"middle\" align=\"center\">"
                + "<div class=\"PlayButtonBackground\"></div>"
                + "<div class=\"PlayButton\" onclick=\"gsPlayVideoWithVideoIndex(" + videoIndex + ")\"></div>"
                + "</td>"
                + "</tr>"
                + "</table>";
        }
    }
    document.write(videoHTML);
}