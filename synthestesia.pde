/**
  * This sketch demonstrates how to use an FFT to analyze
  * the audio being generated by an AudioPlayer.
  * <p>
  * FFT stands for Fast Fourier Transform, which is a
  * method of analyzing audio that allows you to visualize
  * the frequency content of a signal. You've seen
  * visualizations like this before in music players
  * and car stereos.
  * <p>
  * For more information about Minim and additional features,
  * visit http://code.compartmental.net/minim/
  */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer song;
FFT         fft_left;
FFT         fft_right;

int FFT_SAMPLES = 1024 * 2;
int BAR_WIDTH;

void setup()
{
  size(2048, 400, P3D);

  minim = new Minim(this);

  // specify that we want the audio buffers of the AudioPlayer
  // to be 1024 samples long because our FFT needs to have
  // a power-of-two buffer size and this is a good size.
  song = minim.loadFile("example-music/bensound-acousticbreeze.mp3", FFT_SAMPLES);

  song.play();

  // create an FFT object that has a time-domain buffer
  // the same size as song's sample buffer
  // note that this needs to be a power of two
  // and that it means the size of the spectrum will be half as large.
  fft_left = new FFT( song.bufferSize(), song.sampleRate() );
  fft_right = new FFT( song.bufferSize(), song.sampleRate() );

  BAR_WIDTH = 8;

}

void draw()
{
  background(0);
  stroke(255);

  fft_left.forward(song.left);
  fft_right.forward(song.right);

  for(int i = 0; i < fft_left.specSize(); i++)
  {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    rect(i*BAR_WIDTH, height/2 - 1, BAR_WIDTH, 0 - fft_left.getBand(i)*8);
    rect(i*BAR_WIDTH, height/2 + 1, BAR_WIDTH, 0 + fft_right.getBand(i)*8);
  }

  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, height/4 + song.left.get(i)*50, i+1, height/4 + song.left.get(i+1)*50);
    line(i, 3*height/4 + song.right.get(i)*50, i+1, 3*height/4 + song.right.get(i+1)*50);
  }
}
