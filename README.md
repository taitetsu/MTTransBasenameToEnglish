Tranlate Basename to English for Movable Type
=======================

Plug-in for MovableType. Translates Entry Title or arbitrary input strings into English, and inserted to Basename. 

This plug-in uses Microsoft Translator as a translation engine.

##Requirement

+ Client ID and Client Secret for application of Microsoft Translator

##Install

+ Copy plugins/MTTransBasenameToEnglish directory under your Movable Type plugins directory.

##How to Use

###Plugin Settings

1. Go to System/Website/blog -> Tools -> Plugins screen.
2. Click this plugin's name and click "Settings".
3. Input Client ID and Client Secret.
4. Click "Save changes" button.

###Edit Entry

1. Go to Edit Entry screen.
2. Input string to "String to translate" textbox.
3. Or, click "Copy Title" button. Entry title is copied.
4. Click "Translate" button.
5. English basename is inserted.

##Specification

+ HTML tag is removed.
+ Single quote, dot, equal and comma is removed.
+ Blank is replaced to underscore.
+ Double underscore is replaced to single.
+ "Translatie" button overwrites basename.

##License

The MIT License (MIT)

Copyright (c) 2014 Taitetsu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
