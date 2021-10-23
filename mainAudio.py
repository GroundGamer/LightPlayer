import time
import queue
import simpleaudio as sa
from threading import Thread
from pydub import AudioSegment

PATHLESS = './Music/'
MUSICFILEWAV = 'Sound.wav'
MUSICFILEWAVUPD = 'Sound1.wav'


def playMusic():
    arg = []
    que = queue.Queue()
    thread = Thread(target=lambda ques, arg1: ques.put(_stopWatch(arg1)), args=(que, arg,), daemon=True)
    wave_obj = sa.WaveObject.from_wave_file(PATHLESS + MUSICFILEWAV)
    play_obj = wave_obj.play()
    thread.run()
    q = input("Press q and stop audio: \n")
    if q == 'q' or q == 'й' or q == 'Q':
        arg.append(1)
        play_obj.stop()
        play_obj.wait_done()
        thread.join()
        result = que.get()
        print(result)
        song = AudioSegment.from_file(PATHLESS + MUSICFILEWAV, "wav")
        duration_second = len(song) / 1000
        stopAtTheSecond = (duration_second - result)*1000
        lately = song[-stopAtTheSecond:]
        lately.export(PATHLESS + MUSICFILEWAVUPD, 'wav')
        wave_obj1 = sa.WaveObject.from_wave_file(PATHLESS + MUSICFILEWAVUPD)
        play_obj1 = wave_obj1.play()
        play_obj1.wait_done()


def _stopWatch(arg):
    sec = 0
    while len(arg) != 2:
        time.sleep(1)
        sec += 1
        # print(sec)
        if len(arg) == 1:
            arg.append(2)
            return sec


playMusic()
