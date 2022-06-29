# Speech-Recognition-Simulation-using-Verilog
Our project aimed at developing a Real-Time Speech Recognition Engine on an FPGA using Altera DE2 board. The system was designed so as to recognize the word being spoken into the microphone. As large number of accents spoken around the world that this conundrum still remains an active area of research. Speech Recognition finds numerous applications including health care, artificial intelligence, human-computer interaction, Interactive Voice Response Systems, military, avionics, etc. Another most important application resides in helping physically-challenged people to interact with the world in a better way.
## Problem Identification, Need of Speech Recognition System:
We want to solve the problem of deaf people by enabling them to read what is being spoken and take part in the conversation. The problem we are trying to solve is the problem of speech recognition in a faster and accurateway.

Talking to Robots: Robots are more and more being hired in roles related to services and technology so to interact with them we need better speech recognition systems.
Controlling Digital Devices: To interact with Digital virtual assistance like
Google assistance, We need a medium to interact i.e. Voice hence we need
Speech recognition systems.

Aiding the Visually: and Hearing-Impaired: there are many human beings with visible impairments who depend on screen readers and textual content-to-speech dictation structures. So Textual content into audio is an important verbal exchange tool for the visually impaired.

Enabling Hands-Free Technology: Many times our eyes and hands are busy, like while driving, speech is very useful. The ability to communicate with Google Maps to take you to your destination reduces your chances of getting lost and removes the need to pull over and navigate a phone or read a map.

## Objectives:
Our objective is to implement a Real-Time Speech Recognition Engine that
takes as an input the time domain signal from a microphone and performs
the frequency domain feature extraction on the sample to identify the word
being spoken. Our design will exploit the fact that most of the words spoken
across various accents around the world have some common frequency
domain features that can be used to identify the word.
We will even focus on the transformations which are needed to be
performed on the speech sample in order to derive a characteristic to
identify a word.

## Detailed Methodology
## Step 1: Data Acquisition:
We need a speech input device Microphone.The output of the microphone is converted into a digital signal using an ADC
## Step 2: Data Processing
Signal Framing:
End-point detection (EPD):
Pre-emphasis:
Hamming:
## Step 3: Feature Extraction
FFT & DFT
Experimental Design:
## FRONT END :
● USER INTERFACE TO GIVE INPUT SPEECH AND SHOW THE OUTPUT
TO THE USER.
## BACK END (FPGA board+MATLAB ):
● MATLAB for processing the input speech signal and transmitting it
to the FPGA
● UART Verilog module for receiving speech signal from the laptop to
FPGA
● FFT and DCT Verilog MODULE to apply FFT on the speech signal.
● SPEECH recognition Verilog MODULE for applying algorithms to
recognize the speech.
● Led 7 segment display to show the output.
## Design Analysis:
#Front END:
User interface will be a MATLAB program asking for speech input from the
user.
either for recognition OR registering the user.
Backend:
At the back end first, the recorded speech signal will be processed using
Matlab. We will be using Matlab library functions for processing the signal
and then The processed single will be transmitted to the FPGA board. And
on The FPGA board, a main top-level module(which is the SPEECH
RECOGNITION MODULE) will be recognizing this input speech.
## Algorithm Development:
Algorithm of UART
1. The baud generator divides the system clock frequency and generates a UART clock that will be 16 times the baud rate of the UART.
2. For this division, we need a counter register (uart_tick) which counts to a certain final value and when it reaches this final value a pulse needs to be generated . The final value for a particular baud rate is calculated by

3. The UART CLOCK thus generated is used as an input clock for the receiving and transmitting circuit of the UART.


## Algorithm for Reciever Module
The receiver module takes in the UART clock and rx register as inputs. The
output of the receiver is the data received with the start and stop bits
removed. The rx_done_tick is set when the data is received completely and
correctly.
● This module is an FSM having 4 states-which are the idle, start,
data, and stop states.
● IDLE: In the idle state we wait for the start bit to be detected from
the receiving data rx, which happens when rx =0 that is a low pulse
determines the start bit has arrived and the FSM moves to the start state.
● START: Once the start bit is detected we start a counter(s) which
counts from 0 to 16 by using the UART clock. If the rx stays 0 till the counter
counts till 8 then the start bit is recognized and now the data received has to
start so the FSM goes to the data state.
● DATA: After recognizing the start bit the Data bits are sampled by
using the same s counter
which counts from 0 to 16 and the data will always be sampled when the
counter reaches at the middle of its count. Also, a bit counter (n) keeps track
of the number of data bits sampled after each sampling. If the maximum no
of bits to be sampled has reached then the data sampling should stop by
moving to the stop state
● STOP:
For the stop bit to be recognized The rx should be high for a certain
number of counts counted by the s counter and the stop bit is recognized
and the state moves to the idle state again and the whole thing repeats.

## UART PARITY Algorithm
WE WILL ALSO USE A PARITY MODULE TO CHECK THE CORRECTNESS OF THERECEIVED DATA.
So ALONG WITH THE START AND STOP BITS THE TRANSMITTER WILL ALSO SEND A PARITY BIT. THE PARITY CAN BE EVEN OR ODD. IF THE PARITY IS SELECTED TO BE EVEN THEN THE PARITY BIT WILL BE 0 FOR AN EVEN NUMBER OF 1’S IN THE DATA ELSE IT WILL BE SET TO 1 FOR ODD NO OF 1’S .SO THE WAY WE WILL CHECK THE DATA TO BE CORRECT OR NOT WILL BE BY USING A UART parity
MODULE. tHIS MODULE WILL CHECK THE RECEiVED DATA AND CALCULATES THE PARITY OF THE DATA. IF THIS CALCULATED PARITY MATCHES THE PARITY BIT COMING FROM THE TRANSMITtED DATA THEN THE DATA RECEIVED IS VALID ELSE THE DATA IS CORRUPTED.

## Standards Adopted:
RS232 is a standard protocol used for serial communication, so we have used this standard and
developed our UART modules. The two widely used baud rates in this standard are 9600,
115200 bits per second. Out of which we chose 9600 for our project.
Then the speech signal to be taken as input is sampled at a sampling rate of 8kHz which is a
standard used for speech signals.
Trade-Off Identified:
DTW (Dynamic Time warping ) algorithm which we are using for speech recognition has better
accuracy as compared to other faster but less accurate methods of signal recognition.
Also for data communication, we have traded off other faster communication protocols such as
I2C ,SPI etc because our project does not require very high-speed data communication and the
implementation of UART is much simpler than other communication standards.

