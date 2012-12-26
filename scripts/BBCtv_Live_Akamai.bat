@echo off

::  *** Select Channel ***            [ MediaSelector ID ]

    SET ID=bbc_one_london
::  SET ID=bbc_two_england
::  SET ID=bbc_three
::  SET ID=bbc_four


::  *** Select Bitrate ***            [ MediaSelector Bitrate ]

::  SET bitrate=56
::  SET bitrate=176
::  SET bitrate=396
::  SET bitrate=480
    SET bitrate=796
::  SET bitrate=1500


::  *** Select Supplier ***           [ MediaSelector Supplier ]           !! This script ONLY works for an AKAMAI server !!

    SET supplier=akamai


::  *** Media Selector pages ***

::  http://www.bbc.co.uk/mediaselector/4/mtis/stream/bbc_one_london
::  http://www.bbc.co.uk/mediaselector/4/mtis/stream/bbc_two_england
::  http://www.bbc.co.uk/mediaselector/4/mtis/stream/bbc_three
::  http://www.bbc.co.uk/mediaselector/4/mtis/stream/bbc_four



::  *** Port ***
    SET port=1935

::  *** RTMPDump v2.4 (RTMPDump v2.1d doesn't work) ***
    SET rtmpdump=C:\\Program Files (x86)\\rtmpdump\\rtmpdump.exe

::  *** SWF File ***
    SET swf=http://www.bbc.co.uk/emp/releases/iplayer/revisions/617463_618125_4/617463_618125_4_emp.swf

::  *** File Name ***
    SET currDate=%date:/=-%
    SET currTime=%time::=-%

::  *** Safety Tests ***
    IF EXIST "%temp%\*.bat" DEL "%temp%\*.bat"
    IF EXIST "%temp%\*.htm" DEL "%temp%\*.htm"



::  *** Create a HTML file : AKAMAI ***

ECHO ^<html^>                                                                                             >> %temp%\temp.htm
ECHO ^<head^>                                                                                             >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO ^<title^>Parse BBC iPlayer XML File - Javascript Method^</title^>                                    >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO ^<!-- Downloading from a BBC iPlayer page --^>                                                       >> %temp%\temp.htm
ECHO ^<!-- This parses the elements in a MediaSelector XML page --^>                                      >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO ^<SCRIPT^>                                                                                           >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO // Target XML file's URL address [MediaSelector URL]                                                 >> %temp%\temp.htm
ECHO var url = "http://www.bbc.co.uk/mediaselector/4/mtis/stream/%ID%";                                   >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO var xmlDoc;                                                                                          >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO window.open('','_self'); // This prevents the browser window prompting before closing                >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO function loadXML()                                                                                   >> %temp%\temp.htm
ECHO {                                                                                                    >> %temp%\temp.htm
ECHO    xmlDoc = new ActiveXObject("Microsoft.XMLDOM");                                                   >> %temp%\temp.htm
ECHO    xmlDoc.async = false;                                                                             >> %temp%\temp.htm
ECHO    xmlDoc.onreadystatechange = readXML;                                                              >> %temp%\temp.htm
ECHO    xmlDoc.load(url);                                                                                 >> %temp%\temp.htm
ECHO }                                                                                                    >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO function readXML()                                                                                   >> %temp%\temp.htm
ECHO {                                                                                                    >> %temp%\temp.htm
ECHO    if(xmlDoc.readyState == 4) {                                                                      >> %temp%\temp.htm
ECHO    // This function is called on statechange                                                         >> %temp%\temp.htm
ECHO    // When the state reaches 4 this function reads the xml document                                  >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // Create a Text File                                                                             >> %temp%\temp.htm
ECHO    var fso = new ActiveXObject("Scripting.FileSystemObject");                                        >> %temp%\temp.htm
ECHO    var fh = fso.CreateTextFile("C:\\MediaSelector.bat",true);   >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // LEVEL 1 TAGS  [Primary tags]                                                                   >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // Specify the Level 1 tag to loop through                                                        >> %temp%\temp.htm
ECHO    var a = xmlDoc.getElementsByTagName("media");                                                     >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // Loop instruction                                                                               >> %temp%\temp.htm
ECHO    for (i=0;i^<a.length;i++) {                                                                       >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Specify a target element within the Level 1 tag                                            >> %temp%\temp.htm
ECHO        // Specified element must exist in ALL the Level 1 tags                                       >> %temp%\temp.htm
ECHO        element1 = a[i].attributes.getNamedItem("kind").nodeValue; // create array          [Line 50] >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Conditional Filter                                                                         >> %temp%\temp.htm
ECHO        // Pass only those tags that contain video data                                               >> %temp%\temp.htm
ECHO        if ( element1=="video" ) {                                                                    >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Test value of chosen element within this IF condition                                      >> %temp%\temp.htm
ECHO        // alert( "Video = " + element1 );                                                            >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO            // Conditional Filter [Bitrate]                                                           >> %temp%\temp.htm
ECHO            // Pass only the tag that contains the desired bitrate                                    >> %temp%\temp.htm
ECHO            element2 = a[i].attributes.getNamedItem("bitrate").nodeValue; // create array             >> %temp%\temp.htm
ECHO            if ( element2==%bitrate% ) {                                                              >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO            // NOTE: The element "bitrate" can't be used as the primary filter at line 50,            >> %temp%\temp.htm
ECHO            //       because it's an element that does NOT exist in all primary level tags            >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO            // Test value of chosen element within this IF condition                                  >> %temp%\temp.htm
ECHO            // alert( "Bitrate = " + element2 );                                                      >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // LEVEL 2 TAGS  [Child tags]                                                                     >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // Loop through each Child tag                                                                    >> %temp%\temp.htm
ECHO    var b = a[i].childNodes;                                                                          >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO    // Loop instruction                                                                               >> %temp%\temp.htm
ECHO    for (j=0;j^<b.length;j++) {                                                                       >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Specify a target element within the Child tag                                              >> %temp%\temp.htm
ECHO        // Specified element must exist in ALL the Child tags                                         >> %temp%\temp.htm
ECHO        element3 = b[j].attributes.getNamedItem("supplier").nodeValue; // create array                >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Conditional Filter [Supplier]                                                              >> %temp%\temp.htm
ECHO        // Pass only the Child tag that contains the desired supplier                                 >> %temp%\temp.htm
ECHO        if ( element3=="%supplier%" ) {                                                               >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Test value of chosen element within this IF condition                                      >> %temp%\temp.htm
ECHO        // alert( "Supplier = " + element3 );                                                         >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        // Write elements in selected Child tag to file                                               >> %temp%\temp.htm
ECHO        fh.WriteLine( '@echo off' );                                                                  >> %temp%\temp.htm
ECHO        fh.WriteLine( ':: Media tag #' + [i] + ', Child tag #' + [j] );                               >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET rtmpdump=%rtmpdump%' );                                                    >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET protocol='    + b[j].attributes.getNamedItem("protocol").nodeValue    );   >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET server='      + b[j].attributes.getNamedItem("server").nodeValue      );   >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET application=' + b[j].attributes.getNamedItem("application").nodeValue );   >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET identifier='  + b[j].attributes.getNamedItem("identifier").nodeValue  );   >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        var str1=b[j].attributes.getNamedItem("authString").nodeValue;                                >> %temp%\temp.htm
ECHO        fh.WriteLine( 'SET authString=' + str1.replace(/^&/g,"^&") );                                 >> %temp%\temp.htm
ECHO        fh.WriteLine( '' );                                                                           >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm

::          NOTES: 1. The symbol & must be carat-escaped using REPLACE (character to replace, replacement character).
::                 2. A carat (symbol ^) must preceed & in the first argument; g [global] means replace ALL instances.
::                 3. In second argument no escaping is needed: use of double quotes forces the symbols to be read literally

ECHO        fh.WriteLine( '::  *** Command Line : TV : AKAMAI : %bitrate% kbps ***' );                    >> %temp%\temp.htm
ECHO        fh.WriteLine( '"%%rtmpdump%%" --live --verbose '                                        +     >> %temp%\temp.htm
ECHO                      '-r "%%protocol%%://%%server%%:%port%/%%application%%?%%authString%%" '   +     >> %temp%\temp.htm
ECHO                      '-a "%%application%%?%%authString%%" -y "%%identifier%%?%%authString%%" ' +     >> %temp%\temp.htm
ECHO                      '-f "WIN 11,1,102,63" -W "%swf%" '                                        +     >> %temp%\temp.htm
ECHO                      '-o "Live %ID% ['+element2+'kbps] ['+element3+'] %currDate% %currTime%.flv" '); >> %temp%\temp.htm

::          NOTES: 1. The symbol % must be doubled in a Batch file (in contrast to a Command Line).

ECHO.                                                                                                     >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO        }   }         // Close Level 2                                                                >> %temp%\temp.htm
ECHO        }   }   }     // Close Level 1                                                                >> %temp%\temp.htm
ECHO    }                                                                                                 >> %temp%\temp.htm
ECHO }                                                                                                    >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO ^</SCRIPT^>                                                                                          >> %temp%\temp.htm
ECHO.                                                                                                     >> %temp%\temp.htm
ECHO ^</head^>                                                                                            >> %temp%\temp.htm
ECHO ^<body onload="loadXML();window.close()"^> ^</body^>                                                 >> %temp%\temp.htm
ECHO ^</html^>                                                                                            >> %temp%\temp.htm


::  *** Run HTM file in Internet Explorer ***
"C:\Program Files (x86)\Internet Explorer\IEXPLORE.EXE" %temp%\temp.htm

::  *** Run MediaSelector.bat ***
CALL "C:\MediaSelector.bat"

pause
