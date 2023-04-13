# 連想漢字蝶番　Rensou Kanji Hinge (FLUTTER BUILD -- WIP --Currently rebuilding to include Simp & Trad Chinese)
  
  ## The below information concerns the [JS/HMTL/CSS version](https://github.com/CallumBeaney/rensou-kanji-hinge) I prototyped this with.
  
   
  
<img style="width:250px;" src="https://raw.githubusercontent.com/CallumBeaney/rensou-kanji-hinge/master/images/demo.gif"></img>

# 情報と使用法・ABOUT 

漢字の部首を連想することで漢字の手習いの為の携帯サイトです。描きながら、直上の六つの四角に自動手書き認識ソフトは描いた漢字を推測します。選びが成功すれば、成功欄に追加されます。部首を共有する漢字を思い出せない場合｢、｣と｢。｣ボタンを押すと新しい列を始めます。ある漢字の情報が欲しければその漢字を押してください。

This is a smartphone-oriented web app for practicing hand-writing kanji by chaining them by their shared components, based on how I used to furtively practice kanji on a notepad when I worked in a restaurant:

### <br><center> 虫 虹 工 紅。寸 吋 囗 吐 土。暑、寒、暖。  </center>
<br>  
Write a kanji in the white box. Tap your kanji when it appears in one of the grey boxes to add it to the list. Tap the **、** or **。** buttons to start a new sequence. Tap **〒** to export. If you want to know more about a kanji, tap on it. Functionality for working on a computer is included: write in the canvas, and then press the **送信** button.

<br><img style="width:450px" src="https://raw.githubusercontent.com/CallumBeaney/rensou-kanji-hinge/master/images/demopair.jpg"></img>

<br>

# Learning  
Moving from JS/HTML/CSS to Dart was quite a challenge and required a bit of collaboration.  
Implementing a good architecture by separating business logic from UI widgets with a state management Cubit, as well as using streams and singletons for handling Google ML Kit API calls initially, and dictionary objects.

# Dictionary information

DICTIONARY SOURCES:  

EDRDG's [KANJIDIC](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project).  
Michael Raine & Jim Breen's [KRADFILE](http://www.edrdg.org/krad/kradinf.html).  
Shang's *[Kanji Frequency on Wikipedia](https://docs.google.com/spreadsheets/d/18uV916nNLcGE7FqjWH4SJSxlvuT8mM4J865u0WvqlHU/edit?usp=sharing)* spreadsheet.  
  
DICTIONARY STRUCTURE:  
The dictionary follows basic JSON form but is adapted to a Dart object (Map<String, Map<String, String?>>). The keys are as follows:

    KEY :
          index_KD     = KANJIDIC採番   =  The entry kanji's EDRGD "KANJIDIC" dictionary number **
          radicals     = 部首           =  Components of the entry kanji
          strokes      = 字画           =  The entry kanji's stroke count
          freq_news    = 新聞にある頻度版 =  The frequency at which characters appear in newspapers
          freq_wiki    = 新聞にある頻度版 =  The frequency at which characters appear on JP Wikipedia
          english      = 英語の意味      =  The entry kanji's english meaning
          on_kanji     = 音読み漢字      =  Words using the kanji's onyomi, in kanji form
          on_kana      = 音読み仮名      =  Words using the kanji's onyomi, in kana form
          kun_kanji    = 訓読み漢字      =  Words using the kanji's kunyomi, in kanji form
          kun_kana     = 訓読み仮名      =  Words using the kanji's kunyomi, in kana form
          heisig_word     = ハイシッグの暗記言葉 = Heisig's Remembering The Kanji keyword
          heisig_ind      = ハイシッグの採番    = Heisig's index number
          kanji_readings  = 漢字の発音、読み方  = The entry kanji's pronunciations 

    ** This variable is essential for maintaining order when referencing the CKRD and when cross-referencing other dictionaries using the EDRGD KANJIDIC system 
