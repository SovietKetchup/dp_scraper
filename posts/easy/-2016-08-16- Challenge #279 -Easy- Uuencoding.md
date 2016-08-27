# DETAILS
### Title      : [2016-08-16] Challenge #279 [Easy] Uuencoding
### URL        : https://www.reddit.com/r/dailyprogrammer/comments/4xy6i1/20160816_challenge_279_easy_uuencoding/
### Perma-Link : /r/dailyprogrammer/comments/4xy6i1/20160816_challenge_279_easy_uuencoding/
### Score      : 87
### Comments   : 63

# DESCRIPTION
You are trapped at uninhabited island only with your laptop. Still you don't want your significant other to worry about you, so you are going to send a message in a bottle with your picture or at least a couple of words from you (sure, you could just write down the words, but that would be less fun). You're going to use uuencoding for that.

Uuencoding is a form of binary-to-text encoding, which uses only symbols from 32-95 diapason, which means all symbols used in the encoding are printable.

#Description of encoding

A uuencoded file starts with a header line of the form:

    begin &lt;mode&gt; &lt;file&gt;&lt;newline&gt;

&lt;mode&gt; is the file's Unix file permissions as three octal digits (e.g. 644, 744). For Windows 644 is always used.

&lt;file&gt; is the file name to be used when recreating the binary data.

&lt;newline&gt; signifies a newline character, used to terminate each line.

Each data line uses the format:

    &lt;length character&gt;&lt;formatted characters&gt;&lt;newline&gt;

&lt;length character&gt; is a character indicating the number of data bytes which have been encoded on that line. This is an ASCII character determined by adding 32 to the actual byte count, with the sole exception of a grave accent "`" (ASCII code 96) signifying zero bytes. All data lines except the last (if the data was not divisible by 45), have 45 bytes of encoded data (60 characters after encoding). Therefore, the vast majority of length values is 'M', (32 + 45 = ASCII code 77 or "M").


&lt;formatted characters&gt; are encoded characters.

The mechanism of uuencoding repeats the following for every 3 bytes (if there are less than 3 bytes left, trailing 0 are added):

1. Start with 3 bytes from the source, 24 bits in total.

2. Split into 4 6-bit groupings, each representing a value in the range 0 to 63: bits (00-05), (06-11), (12-17) and (18-23).

3. Add 32 to each of the values. With the addition of 32 this means that the possible results can be between 32 (" " space) and 95 ("_" underline). 96 ("`" grave accent) as the "special character" is a logical extension of this range.

4. Output the ASCII equivalent of these numbers.


For example, we want to encode a word "Cat". ASCII values for C,a,t are 67,97,116, or  `010000110110000101110100` in binary. After dividing into four groups, we get 010000 110110 000101 110100, which is 16,54,5,52 in decimal. Adding 32 to this values and encoding back in ASCII, the final result is `0V%T`.

The file ends with two lines:

    `&lt;newline&gt;
    end&lt;newline&gt;
#Formal Inputs &amp; Outputs
##Input
a byte array or string.
##Output
a string containing uuencoded input.

#Examples
Input: Cat

Output:
 
    begin 644 cat.txt
    #0V%T
    `
    end

Input:
I feel very strongly about you doing duty. Would you give me a little more documentation about your reading in French? I am glad you are happy — but I never believe much in happiness. I never believe in misery either. Those are things you see on the stage or the screen or the printed pages, they never really happen to you in life.


Output:

    begin 644 file.txt
    M22!F965L('9E&lt;GD@&lt;W1R;VYG;'D@86)O=70@&gt;6]U(&amp;1O:6YG(&amp;1U='DN(%=O
    M=6QD('EO=2!G:79E(&amp;UE(&amp;$@;&amp;ET=&amp;QE(&amp;UO&lt;F4@9&amp;]C=6UE;G1A=&amp;EO;B!A
    M8F]U="!Y;W5R(')E861I;F&lt;@:6X@1G)E;F-H/R!)(&amp;%M(&amp;=L860@&gt;6]U(&amp;%R
    M92!H87!P&gt;2#B@)0@8G5T($D@;F5V97(@8F5L:65V92!M=6-H(&amp;EN(&amp;AA&lt;'!I
    M;F5S&lt;RX@22!N979E&lt;B!B96QI979E(&amp;EN(&amp;UI&lt;V5R&gt;2!E:71H97(N(%1H;W-E
    M(&amp;%R92!T:&amp;EN9W,@&gt;6]U('-E92!O;B!T:&amp;4@&lt;W1A9V4@;W(@=&amp;AE('-C&lt;F5E
    M;B!O&lt;B!T:&amp;4@&lt;')I;G1E9"!P86=E&lt;RP@=&amp;AE&gt;2!N979E&lt;B!R96%L;'D@:&amp;%P
    3&lt;&amp;5N('1O('EO=2!I;B!L:69E+C P
    `
    end

#Bonuses
##Bonus 1
Write uudecoder, which decodes uuencoded input back to a byte array or string
##Bonus 2
Write encoder for files as well.
##Bonus 3
Make encoding parallel.
#Further Reading
[Binary-to-text encoding](https://en.wikipedia.org/wiki/Binary-to-text_encoding) on Wikipedia.

#Finally

This challenge is posted by /u/EvgeniyZh

Also have a good challenge idea?

Consider submitting it to /r/dailyprogrammer_ideas