from __future__ import print_function

import os
import sys
import math

import pygame

from pydub import AudioSegment
from PyQt5 import QtCore, QtQml, QtWidgets
from PyQt5.QtCore import QUrl, QDir


class PyGameSound(QtCore.QObject):
    sourceChanged = QtCore.pyqtSignal()
    volumeChanged = QtCore.pyqtSignal()
    stateChanged = QtCore.pyqtSignal()
    stateVolumeChanged = QtCore.pyqtSignal()
    stateMusicChanged = QtCore.pyqtSignal()
    notifyIntervalChanged = QtCore.pyqtSignal()
    progressChanged = QtCore.pyqtSignal()
    timeMusicChanged = QtCore.pyqtSignal()
    timeMusicChangedMin = QtCore.pyqtSignal()
    statictimeMusicChangedMin = QtCore.pyqtSignal()
    statictimeMusicChangedSec = QtCore.pyqtSignal()
    notifyIntervalTimeMusicChanged = QtCore.pyqtSignal()
    changedStateFinal = QtCore.pyqtSignal()

    error = QtCore.pyqtSignal(str, arguments=["message"])

    class State:
        PlayingState, PausedState, StoppedState, FinalState = range(4)

    class StateVolume:
        EnabledSound, DisabledSound = range(2)

    class StateMusic:
        EnabledMusic, DisabledMusic = range(2)

    QtCore.Q_ENUMS(State)
    QtCore.Q_ENUMS(StateVolume)
    QtCore.Q_ENUMS(StateMusic)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.destroyed.connect(self.on_destroyed)
        pygame.mixer.init(44100, -16, 2, 512)

        self._source = ""
        self._notifyInterval = 1000
        self._notifyIntervalTime = 1000
        self._progress = 0.0
        self._volume = 1.0
        self._runningTimeMusic = 0
        self._runningTimeMusicMin = 0
        self._runningStaticTimeMusicSec = 0
        self._runningStaticTimeMusicMin = 0
        self._notify_timer = QtCore.QTimer(self, timeout=self.on_notify_callback)
        self._notify_timer_time_music = QtCore.QTimer(self, timeout=self.timingSec)

        self._state = PyGameSound.State.StoppedState
        self._state_volume = PyGameSound.StateVolume.EnabledSound
        self._state_music = PyGameSound.StateMusic.DisabledMusic

    # --- код на обновление шкалы времени ---
    @QtCore.pyqtProperty(State, notify=stateChanged)
    def state(self):
        return self._state

    def _update_state(self, state):
        self._state = state
        self.stateChanged.emit()

    def on_notify_callback(self):
        if self.source:
            try:
                song = pygame.mixer.Sound(self.source)
                total = song.get_length()
                pos = pygame.mixer.music.get_pos()
                total_from_state = song.get_length() - .1
                pos_from_state = pygame.mixer.music.get_pos() / 1000.0
                if pos >= 0:
                    percentage = pos / (total * 1000.0)
                    if math.isclose(percentage, 1.0, abs_tol=self.notifyInterval / 1000.0):
                        percentage = 1.0
                    if pos_from_state >= total_from_state:
                        self.changedStateFinal.emit()
                        self._update_state(PyGameSound.State.StoppedState)
                        self._update_state_music(PyGameSound.StateMusic.DisabledMusic)
                    self.progress = percentage
            except pygame.error as message:
                self.error.emit(str(message))

    @QtCore.pyqtProperty(int, notify=notifyIntervalChanged)
    def notifyInterval(self):
        return self._notifyInterval

    @notifyInterval.setter
    def notifyInterval(self, interval):
        if self._notifyInterval != interval:
            self._notifyInterval = interval
            is_active = self._notify_timer.isActive()
            if is_active:
                self._notify_timer.stop()
            self._notify_timer.setInterval(self._notifyInterval)
            if is_active:
                self._notify_timer.start()

    @QtCore.pyqtProperty(float, notify=progressChanged)
    def progress(self):
        return self._progress

    @progress.setter
    def progress(self, progress):
        self._progress = progress
        self.progressChanged.emit()

    # --- конец кода ---

    # --- Код на обновление секунд ---
    @QtCore.pyqtProperty(int, notify=notifyIntervalTimeMusicChanged)
    def notifyIntervalTimeMusic(self):
        return self._notifyIntervalTime

    @notifyIntervalTimeMusic.setter
    def notifyIntervalTimeMusic(self, interval):
        if self._notifyIntervalTime != interval:
            self._notifyIntervalTime = interval
            is_active = self._notify_timer_time_music.isActive()
            if is_active:
                self._notify_timer_time_music.stop()
            self._notify_timer_time_music.setInterval(self._notifyIntervalTime)
            if is_active:
                self._notify_timer_time_music.start()

    def timingSec(self):
        self.staticTimingMin(1)
        self.staticTimingSec(1)
        pos = pygame.mixer.music.get_pos()
        total = pos // 1000.0
        total1 = pos // 1000.0
        if total1 >= 60:
            self.timingMin(1)
            total = total - 60
        if total1 >= 120:
            self.timingMin(2)
            total = total - 60
        if total1 >= 180:
            self.timingMin(3)
            total = total - 60
        if total1 >= 240:
            self.timingMin(4)
            total = total - 60
        if total1 >= 300:
            self.timingMin(5)
            total = total - 60
        if total1 >= 360:
            self.timingMin(6)
            total = total - 60
        if total1 >= 420:
            self.timingMin(7)
            total = total - 60
        if total1 >= 480:
            self.timingMin(8)
            total = total - 60
        if total1 >= 540:
            self.timingMin(9)
            total = total - 60
        if total1 >= 600:
            self.timingMin(10)
            total = total - 60

        self.runningMusic = total

    @QtCore.pyqtProperty(float, notify=timeMusicChanged)
    def runningMusic(self):
        return self._runningTimeMusic

    @runningMusic.setter
    def runningMusic(self, runningTimeMusic):
        self._runningTimeMusic = runningTimeMusic
        self.timeMusicChanged.emit()

    # --- конец кода ---

    # --- Код на обновление минут ---
    def timingMin(self, value):
        self.runningMusicMin = value

    @QtCore.pyqtProperty(float, notify=timeMusicChangedMin)
    def runningMusicMin(self):
        return self._runningTimeMusicMin

    @runningMusicMin.setter
    def runningMusicMin(self, runningTimeMusicMin):
        self._runningTimeMusicMin = runningTimeMusicMin
        self.timeMusicChangedMin.emit()

    # --- конец кода ---

    # --- Код на статические минуты ---
    def staticTimingMin(self, value):
        if value == 1:
            song = pygame.mixer.Sound(self.source)
            total = song.get_length()
            resMin = total // 60
            self.runningStaticMusicMin = resMin

    @QtCore.pyqtProperty(float, notify=statictimeMusicChangedMin)
    def runningStaticMusicMin(self):
        return self._runningStaticTimeMusicMin

    @runningStaticMusicMin.setter
    def runningStaticMusicMin(self, runningStaticTimeMusicMin):
        self._runningStaticTimeMusicMin = runningStaticTimeMusicMin
        self.statictimeMusicChangedMin.emit()

    # --- конец кода ---

    # --- Код на статические секунды ---
    def staticTimingSec(self, value):
        if value == 1:
            song = pygame.mixer.Sound(self.source)
            total = song.get_length()
            resSec = total % 60
            self.runningStaticMusicSec = round(resSec)

    @QtCore.pyqtProperty(float, notify=statictimeMusicChangedSec)
    def runningStaticMusicSec(self):
        return self._runningStaticTimeMusicSec

    @runningStaticMusicSec.setter
    def runningStaticMusicSec(self, runningStaticTimeMusicSec):
        self._runningStaticTimeMusicSec = runningStaticTimeMusicSec
        self.statictimeMusicChangedSec.emit()

    # --- конец кода ---

    # --- Код на громкость ---
    @QtCore.pyqtProperty(float, notify=volumeChanged)
    def volume(self):
        return pygame.mixer.music.get_volume()

    @volume.setter
    def volume(self, volume):
        pygame.mixer.music.set_volume(volume)
        self.volumeChanged.emit()

    # --- конец кода ---

    # --- Код на добавление музыки для прослушивания ---
    @QtCore.pyqtProperty(str, notify=sourceChanged)
    def source(self):
        return self._source

    @source.setter
    def source(self, source):
        try:
            pygame.mixer.music.load(source)
        except pygame.error as message:
            self.error.emit(str(message))
            source = ""
        if self._source != source:
            self._source = source
            self.sourceChanged.emit()

    # --- конец кода ---

    @QtCore.pyqtProperty(StateVolume, notify=stateVolumeChanged)
    def stateVolume(self):
        return self._state_volume

    def _update_state_volume(self, stateVolume):
        self._state_volume = stateVolume
        self.stateVolumeChanged.emit()

    @QtCore.pyqtProperty(StateMusic, notify=stateMusicChanged)
    def stateMusic(self):
        return self._state_music

    def _update_state_music(self, stateMusic):
        self._state_music = stateMusic
        self.stateMusicChanged.emit()

    # --- Слоты ---
    @QtCore.pyqtSlot()
    def play(self):
        try:
            pygame.mixer.music.play()
            self._notify_timer.start()
            self._notify_timer_time_music.start()
        except pygame.error as message:
            self.error.emit(str(message))
            return
        self._update_state(PyGameSound.State.PlayingState)
        self._update_state_music(PyGameSound.StateMusic.EnabledMusic)

    @QtCore.pyqtSlot()
    def unPause(self):
        pygame.mixer.music.unpause()
        self._notify_timer.start()
        self._notify_timer_time_music.start()
        self._update_state(PyGameSound.State.PlayingState)
        self._update_state_music(PyGameSound.StateMusic.EnabledMusic)

    @QtCore.pyqtSlot()
    def pause(self):
        pygame.mixer.music.pause()
        self._notify_timer.stop()
        self._notify_timer_time_music.stop()
        self._update_state(PyGameSound.State.PausedState)
        self._update_state_music(PyGameSound.StateMusic.DisabledMusic)

    @QtCore.pyqtSlot()
    def stop(self):
        pygame.mixer.music.stop()
        self._notify_timer.stop()
        self._notify_timer_time_music.stop()
        self._update_state(PyGameSound.State.StoppedState)
        self._update_state_music(PyGameSound.StateMusic.DisabledMusic)

    @QtCore.pyqtSlot()
    def enabledVolume(self):
        self._update_state_volume(PyGameSound.StateVolume.EnabledSound)

    @QtCore.pyqtSlot()
    def disabledVolume(self):
        self._update_state_volume(PyGameSound.StateVolume.DisabledSound)

    @QtCore.pyqtSlot()
    def enabledMusic(self):
        self._update_state_music(PyGameSound.StateMusic.EnabledMusic)

    @QtCore.pyqtSlot()
    def disabledMusic(self):
        self._update_state_music(PyGameSound.StateMusic.DisabledMusic)

    @QtCore.pyqtSlot(str)
    def printTest(self, text):
        print(text)
    # --- end slot ---

    def on_destroyed(self):
        pygame.mixer.quit()


class OpenMusicDialog(QtWidgets.QFileDialog):
    def __init__(self, parent=None):
        super().__init__(parent)

        self._actor = []
        self._title = []
        self._index = []
        self._source = []

    def return_Actor_Titled(self, tuple_file_name):
        list_file_name = tuple_file_name
        copy_list = list_file_name.copy()
        music_number = []
        music_actor = []
        music_titled = []
        index = []
        source = []
        for i in range(len(list_file_name) + 1):
            if len(list_file_name) == 0:
                self.actor = music_actor.pop(0)
                self.titleMusic = music_titled.pop(0)
                self.index = index.pop(0)
                self.source = source.pop(0)
            else:
                res_clear = copy_list.pop(-1)
                source.append(res_clear)
                res = list_file_name.pop(-1).split('/')[-1]
                music_number.append(res)
                if music_actor and music_titled:
                    self.actor = music_actor.pop(0)
                    self.titleMusic = music_titled.pop(0)
                    self.index = index.pop(0)
                    self.source = source.pop(0)
                for j in range(len(music_number)):
                    res_actor = music_number[-1].split(' - ')[0]
                    music_actor.append(res_actor)
                    res_titled = music_number[-1].split(' - ')[-1].split('.wav')[0].split('_1')[0]
                    music_titled.append(res_titled)
                    index.append(i)
                    music_number.clear()

    def showDialog(self):
        PATHLESS = './Music/'
        _file_name = QtWidgets.QFileDialog.getOpenFileNames(self, "Choose music...", QDir.homePath(),
                                                            "MP3 file (*.mp3);;WAV file (*.wav);;OGG File ("
                                                            "*.ogg);;FLV(если кто-то вообще его юзает) (*.flv)")
        tuple_file_name = _file_name
        list_file_name = tuple_file_name[0]
        if list_file_name:
            finished_sheet_music = []
            for i in range(len(list_file_name)):
                if tuple_file_name[1] == 'MP3 file (*.mp3)':
                    mainMusic = list_file_name.pop(0)
                    song = AudioSegment.from_file(mainMusic, 'mp3')
                    res_music = mainMusic.split('/')[-1].split('.mp3')[0]
                    continsMusic = res_music + '_1.wav'
                    finished_sheet_music.append(PATHLESS + continsMusic)
                    song.export(PATHLESS + continsMusic, 'wav')
                elif tuple_file_name[1] == 'WAV file (*.wav)':
                    mainMusic = list_file_name.pop(0)
                    finished_sheet_music.append(mainMusic)
                elif tuple_file_name[1] == 'OGG File (*.ogg)':
                    mainMusic = list_file_name.pop(0)
                    song = AudioSegment.from_file(mainMusic, 'ogg')
                    res_music = mainMusic.split('/')[-1].split('.ogg')[0]
                    continsMusic = res_music + '_1.wav'
                    finished_sheet_music.append(PATHLESS + continsMusic)
                    song.export(PATHLESS + continsMusic, 'wav')
                elif tuple_file_name[1] == 'FLV(если кто-то вообще его юзает) (*.flv)':
                    mainMusic = list_file_name.pop(0)
                    song = AudioSegment.from_file(mainMusic, 'flv')
                    res_music = mainMusic.split('/')[-1].split('.flv')[0]
                    continsMusic = res_music + '_1.wav'
                    finished_sheet_music.append(PATHLESS + continsMusic)
                    song.export(PATHLESS + continsMusic, 'wav')
            OpenMusicDialog.return_Actor_Titled(self, finished_sheet_music)
        else:
            pass

    @property
    def actor(self):
        return self._actor

    @actor.setter
    def actor(self, actor):
        self._actor.append(actor)

    @property
    def titleMusic(self):
        return self._title

    @titleMusic.setter
    def titleMusic(self, titleMusic):
        self._title.append(titleMusic)

    @property
    def index(self):
        return self._index

    @index.setter
    def index(self, index):
        self._index.append(index)

    @property
    def source(self):
        return self._source

    @source.setter
    def source(self, source):
        self._source.append(source)


class MusicDownloadAndSetup(QtCore.QObject):
    changedNameMusicActor = QtCore.pyqtSignal()
    changedNameMusicTitle = QtCore.pyqtSignal()
    changedNameMusicSource = QtCore.pyqtSignal()
    changedNameMusicIndex = QtCore.pyqtSignal()
    addMusicList = QtCore.pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        self.openDialog = OpenMusicDialog()

        self._actorName = ''
        self._titleName = ''
        self._sourceName = ''
        self._indexName = 0

    @QtCore.pyqtProperty(int, notify=changedNameMusicIndex)
    def indexName(self):
        return self._indexName

    @indexName.setter
    def indexName(self, indexName):
        self._indexName = indexName
        self.changedNameMusicIndex.emit()

    @QtCore.pyqtProperty(str, notify=changedNameMusicSource)
    def sourceName(self):
        return self._sourceName

    @sourceName.setter
    def sourceName(self, sourceName):
        self._sourceName = sourceName
        self.changedNameMusicSource.emit()

    @QtCore.pyqtProperty(str, notify=changedNameMusicActor)
    def actorName(self):
        return self._actorName

    @actorName.setter
    def actorName(self, actorName):
        self._actorName = actorName
        self.changedNameMusicActor.emit()

    @QtCore.pyqtProperty(str, notify=changedNameMusicTitle)
    def titleName(self):
        return self._titleName

    @titleName.setter
    def titleName(self, titleName):
        self._titleName = titleName
        self.changedNameMusicTitle.emit()

    @QtCore.pyqtSlot()
    def addMusic(self):
        self.openDialog.showDialog()
        print(self.openDialog.actor)
        print(self.openDialog.titleMusic)
        print(self.openDialog.index)
        print(self.openDialog.source)
        for i in range(len(self.openDialog.actor)):
            self.indexName = self.openDialog.index.pop(0)
            self.sourceName = self.openDialog.source.pop(0)
            self.actorName = self.openDialog.actor.pop(0)
            self.titleName = self.openDialog.titleMusic.pop(0)
            self.addMusicList.emit()
        # self.actorName = self.openDialog.actor
        # self.titleName = self.openDialog.titleMusic

    @QtCore.pyqtSlot(str)
    def printTest(self, text):
        print(text)


if __name__ == "__main__":
    sys.argv += ['--style', 'material']

    current_dir = os.path.dirname(os.path.realpath(__file__))

    QtQml.qmlRegisterType(MusicDownloadAndSetup, "MusicDAS", 1, 0, "MusicDownloadAndSetup")
    QtQml.qmlRegisterType(PyGameSound, "PyGame", 1, 0, "PyGameSound")

    app = QtWidgets.QApplication(sys.argv)
    engine = QtQml.QQmlApplicationEngine()

    filename = os.path.join(current_dir, "LightPlayer.qml")

    engine.load(QUrl.fromLocalFile(filename))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
