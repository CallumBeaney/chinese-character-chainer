<img style="width:300px" src="https://callumbeaney.github.io/index_images/chain.jpg" /></a>   

# 漢字連鎖 Kanji/Hanzi Chainer  
  
This is a smartphone app for practicing hand-writing Chinese characters by chaining them by their shared components, based on how I used to furtively practice kanji on a notepad when I worked in a restaurant e.g.:   
  
### 虫 虹 工 紅。寸 吋 囗 吐 土。暑、寒、暖。 

The app supports Japanese, Traditional Chinese, and Simplified Chinese character sets.  
I originally prototyped a [JS/HMTL/CSS webapp](https://github.com/CallumBeaney/rensou-kanji-hinge) version.  
    
<img style="width:650px;" src="https://raw.githubusercontent.com/CallumBeaney/kanji-hanzi-chainer/master/preview.png">
  
  
# Installation
See the `Releases` section.  
Upon installation the Google ML kit language models will download.  
These cannot be packaged natively [because Google](https://developers.google.com/ml-kit/tips/installation-paths#how_to_choose_between_bundled_and_unbundled).  
This will likely take ~10 seconds.  
Thereafter the app is fully operable offline.  
  
<br>
  
# Dictionary information
  
I hand-rolled these dictionary files out of a want to not rely on any internet connectivity to use this app.
  
Due to the vastness of their size and technical debt incurred by e.g. the ways that researchers broke characters down into radicals using unicode characters (e.g. 拆 => 扌 手 斥	才), very occasionally characters that should match will not, and characters that one wouldn't intuit to be matchable will be able to be matched. This will be cleared up through regular bugfixing by myself as I use these dictionaries.  

### JAPANESE DICTIONARY STRUCTURE:  
The dictionary follows basic JSON form but is adapted to a Dart object (Map<String, Map<String, nullable String>>). 
  
 - EDRDG's [KANJIDIC](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project).  
 - Michael Raine & Jim Breen's [KRADFILE](http://www.edrdg.org/krad/kradinf.html).  
 - Shang's *[Kanji Frequency on Wikipedia](https://docs.google.com/spreadsheets/d/18uV916nNLcGE7FqjWH4SJSxlvuT8mM4J865u0WvqlHU/edit?usp=sharing)* spreadsheet.  
   
```
index_KD     = KANJIDIC採番   =  The entry kanji's EDRGD "KANJIDIC" dictionary number
radicals     = 部首           =  Components of the entry kanji
strokes      = 字画           =  The entry kanji's stroke count
freq_news    = 新聞にある頻度版 =  The frequency at which characters appear in newspapers
freq_wiki    = wikiにある頻度版=  The frequency at which characters appear on JP Wikipedia
english      = 英語の意味      =  The entry kanji's english meaning
on_kanji     = 音読み漢字      =  Words using the kanji's onyomi, in kanji form
on_kana      = 音読み仮名      =  Words using the kanji's onyomi, in kana form
kun_kanji    = 訓読み漢字      =  Words using the kanji's kunyomi, in kanji form
kun_kana     = 訓読み仮名      =  Words using the kanji's kunyomi, in kana form
heisig_word     = ハイシッグの暗記言葉 = Heisig's Remembering The Kanji keyword
heisig_ind      = ハイシッグの採番    = Heisig's index number
kanji_readings  = 漢字の発音、読み方  = The entry kanji's pronunciations 
```        
  
### CHINESE DICTIONARIES:  
  
 - Jun Da 笪骏's [Hanzi Frequency List](https://lingua.mtsu.edu/chinese-computing/statistics/char/list.php?Which=MO).  
 - Denisowski's [CEDICT](https://cc-cedict.org/wiki/).  
 - 開放詞典 (KFCD)'s [Chaizi](https://github.com/kfcd/chaizi).  
   
```
index_jun  = 序号       =  The entry hanzi's serial number as per Jun's index
freq       = 频率       =  Individual raw frequency of character in reference corpus
percentile = 累计频率(%) =  Cumulative frequency in percentile
pinyin     = 拼音       =  Romanized pronunciation of the entry hanzi
jyutping   = 粵拼       =  The Cantonese pronunciation
zhuyin     = 注音       =  The Bopomofo pronunciation
radicals   = 部首       =  Components of the entry hanzi
alt_char   = 繁體字     =  The traditional/simplified alternative of the entry hanzi
english    = 英文翻譯    =  The entry hanzi's english meaning
``` 
