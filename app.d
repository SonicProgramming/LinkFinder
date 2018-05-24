
// By SonicProgramming
import dlangui;
import dlangui.platforms.common.platform;
import std.string;
import std.conv;

mixin APP_ENTRY_POINT;

extern (C) int UIAppMain(string[] args) {
    
    Window window = Platform.instance.createWindow("LinkFinder", null, 0);

    window.mainWidget = parseML(q{
        VerticalLayout {
            margins: 10
            padding: 10
            
            VerticalLayout {                
                TextWidget { text: "Instructions:"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: " "; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: "1 - Upload your file to mediafire/google or yandex drive/dropbox"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: "2 - Get the download link"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: "3 - Paste the link to the field below"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: "4 - Press the button"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: "5 - Receive the direct link in the second field below"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                TextWidget { text: " "; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
            }
            
            VerticalLayout {
                EditLine { id: edit1; text: "paste link here" }
                Button { id: btnOk; text: "Ok" }
                TextWidget { text: "Paste this to \"download URL\" field in \"Create\" tab in GD TPM"; textColor: "black"; fontSize: 100%; fontWeight: 750; fontFace: "Arial" }
                EditLine { id: edit2; text: "get result here" }
            }
        }
    });

    uint wflgs = window.flags;
    wflgs = 0u;
    
    auto edit1 = window.mainWidget.childById!EditLine("edit1");
    auto edit2 = window.mainWidget.childById!EditLine("edit2");
    
    window.mainWidget.childById!Button("btnOk").click = delegate(Widget w) {
        string str1 = text(edit1.text());
        string str2;
        if( indexOf(str1, "dropbox.com") != -1 ) str2 = runDropbox(str1);
        else if ( indexOf(str1, "drive.google.com") != -1 ) str2 = runGoogleDrive(str1);
        else if ( str1.indexOf("yadi.sk") != -1) str2 = runYandexDrive(str1);
        else str2 = "Invalid link entered!";
        dstring result = dtext(str2);
        edit2.text(result);
        return true;
    };

    window.show();

    return Platform.instance.enterMessageLoop();
}

string runDropbox(string initialLink){
    string partOne = substring(initialLink, 8);
    return "https://dl."~partOne~"?dl=1";
}

string runGoogleDrive(string initialLink){
    int beginIndex = initialLink.indexOf("open?id=");
    string fileId = substring(initialLink, beginIndex+8);
    return "https://drive.google.com/uc?export=download&confirm=no_antivirus&id="~fileId;
}

string runYandexDrive(string initialLink){
    return "https://getfile.dokpub.com/yandex/get/"~initialLink;
}

//I couldn't find it in std lib, so i made it myself lol
string substring(string str, int beginIndex, int endIndex){
    string toret = "";
    foreach(i; beginIndex..endIndex){
       toret ~= text(str[i]);
    }
    return toret;
}

string substring(string str, int beginIndex){
    string toret = "";
    foreach(i; beginIndex..str.length){
       toret ~= text(str[i]);
    }
    return toret;
}
