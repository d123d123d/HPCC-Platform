/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

token patWord := PATTERN('[a-z]')+;
token noun := patWord;
target := ['Gavin','Nigel','Richard','David'];
pronoun := ['I','he','you','we','they'];
token verbs := ['hate','detest','loath'] opt('s' | 'es');


token subject := validate(noun, matchtext in pronoun);
token object := validate(noun, matchtext in target);
token action := patWord in verbs;
token anotheraction := action;
rule dislike := subject anotheraction object;

infile := dataset([
        {'I hate gavin.'},
        {'I hate gavinxxx.'},
        {'Personally I think they hate Richard'},
        {'Personally I hate Richard, he loathes Gavin'}
        ], { string line });


results :=
    record
        '\'' + MATCHTEXT(patWord[1]) + '\'';
        '\'' + MATCHTEXT(patWord[2]) + '\'';
        '\'' + MATCHTEXT(patWord[3]) + '\'';
        '\'' + MATCHTEXT(noun[1]) + '\'';
        '\'' + MATCHTEXT(noun[2]) + '\'';
        '\'' + MATCHTEXT(noun[3]) + '\'';
        '\'' + MATCHTEXT(noun/patWord[1]) + '\'';
        '\'' + MATCHTEXT(noun/patWord[2]) + '\'';
        '\'' + MATCHTEXT(noun/patWord[3]) + '\'';
        '\'' + MATCHTEXT(noun[1]/patWord[1]) + '\'';
        '\'' + MATCHTEXT(noun[1]/patWord[2]) + '\'';
        '\'' + MATCHTEXT(noun[2]/patWord[1]) + '\'';
    end;

output(PARSE(infile,line,dislike,results,scan,nocase,skip([' ',',',';','\t','.','$$']*)));
