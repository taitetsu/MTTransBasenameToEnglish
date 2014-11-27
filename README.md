Tranlate Basename to English for Movable Type
=======================

Plug-in for MovableType. Translates Entry Title or arbitrary input strings into English, and inserted to Basename. 

This plug-in uses Microsoft Translator as a translation engine.

##Requirement

+ Client ID and Client Secret for application of Microsoft Translator

##Install

+ Copy plugins/MTTransBasenameToEnglish directory under your Movable Type plugins directory.

##How to Use

1. Go to System/Website/blog -> Tools -> Plugins screen.
2. Click this plugin's name and click "Settings".
3. Input Client ID and Client Secret.
4. Click "Save changes" button.

1. Go to Edit Entry screen.
2. Input string to "String to translate" textbox.
3. Or, click "Copy Title" button. Entry title is copied.
4. Click "Translate" button.
5. English basename is inserted.

##Specification

1. HTML tag is removed.
2. Single quote, dot, equal and comma is removed.
3. Blank is replaced to underscore.
4. Double underscore is replaced to single.
5. "Translatie" button overwrites basename.
