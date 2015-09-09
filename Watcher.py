import StringIO
from pymongo import MongoClient

import sys
from matplotlib.figure import Figure
from matplotlib.backend_bases import key_press_handler
from matplotlib.backends.backend_qt4agg import (
    FigureCanvasQTAgg as FigureCanvas,
    NavigationToolbar2QT as NavigationToolbar)
from PyQt4.QtCore import *
from PyQt4.QtGui import *

from Freezer import Freezer
import pandas as pd

__author__ = 'minosniu'


def indices(func, a):
    return [i for (i, val) in enumerate(a) if func(val)]

class Watcher(QMainWindow):
    """"""

    def __init__(self, freezer, parent=None):
        """Constructor for Viewer"""
        self.freezer = freezer
        self.numTrials = 0
        self.currTrialNum = 0
        self.allTrials = None
        self.allAlignedTrials = None
        self.allOnsets = None
        self.idList = None

        # # Useful stuff
        self.onsetLine1 = None
        self.onsetLine2 = None
        
        self.isDragging = False

        QMainWindow.__init__(self, parent)
        # self.showMaximized()
        self.createMainFrame()
        # self.drawTrial()

    def queryData(self, queryStr):
        """Query some data from freezer
        """
        
        self.idList = []
        
        self.allTrials = []
        self.allAlignedTrials = []
        self.allOnsets = []
        
        self.allQueryResults = {} # {'idxxx': {'var1':value1, 'var2':value2...}}
        self.queryStr = queryStr

        # allDocs = self.freezer.processed.find(eval(self.queryStr))
        allDocs = self.freezer.posts.find(eval(self.queryStr))
        for doc in allDocs:
            s = StringIO.StringIO(doc['trialData'])
            tTrialData = pd.read_csv(s)
            self.allTrials.append(tTrialData)

            t = 0#doc['timeOnset']
            self.allOnsets.append(t)
            
            tId = doc['_id']
            self.idList.append(tId)
            
            self.allQueryResults[tId] = {
                'isAccepted': doc['isAccepted'],
                'trialData': tTrialData,
                'timeOnset': int(0.0)
            }

        self.numTrials = len(self.allTrials)

        # self.allAlignedTrials = [t for t in self.allTrials]
        print "Found", self.numTrials, "trials."

    def freezeAllOnsets(self):
        """Freeze timeOnset field in Freezer
        """
        allDocs = self.freezer.processed.find(eval(self.queryStr))
        try:
            for onset, doc in zip(self.allOnsets, allDocs):
                self.freezer.processed.update({'_id': doc['_id']},
                                              {'$set': {'timeOnset': onset}})
            print("Froze %d onsets" % len(self.allOnsets))
        except:
            print("Error updating")

    def freezeAllIsAccepted(self):
        """Freeze timeOnset field in Freezer
        """
        allDocs = self.freezer.processed.find(eval(self.queryStr))
        try:
            for isAccepted, doc in zip(self.allQueryResults[self.idList[self.currTrialNum]]['isAccepted'], allDocs):
                print isAccepted, doc['_id']
                self.freezer.processed.update({'_id': doc['_id']},
                                              {'$set': {'isAccepted': isAccepted}})
            print("Froze %d isAccepted flags" % len(self.allIsAccepted))
        except:
            print("Error updating")            

    def freezeAllQueryResults(self):
        """Freeze timeOnset field in Freezer
        """        
        try:
            for id in self.idList:
                print id, {'isAccepted': self.allQueryResults[id]['isAccepted']}
                self.freezer.processed.update({'_id': id},
                                              {'$set': {'isAccepted': self.allQueryResults[id]['isAccepted'],
                                                        'timeOnset': int(self.allQueryResults[id]['timeOnset'])}})
            print("Froze %d isAccepted flags" % len(self.idList))
        except:
            print("Error freezing")

    def createMainFrame(self):
        self.main_frame = QWidget()

        self.fig = Figure((5.0, 4.0), dpi=100)
        self.canvas = FigureCanvas(self.fig)
        self.canvas.setParent(self.main_frame)
        self.canvas.setFocusPolicy(Qt.StrongFocus)
        self.canvas.setFocus()

        self.mpl_toolbar = NavigationToolbar(self.canvas, self.main_frame)

        ### Linking some events        
        self.canvas.mpl_connect('key_press_event', self.onKey)
        self.canvas.mpl_connect('pick_event', self.onPick)
        self.canvas.mpl_connect('button_press_event', self.onMouseDown)
        self.canvas.mpl_connect('button_release_event', self.onMouseUp)
        self.canvas.mpl_connect('motion_notify_event', self.onMouseMotion)




        self.textbox = QTextEdit("""{"analystName": "zcwaxs"}
                                 """)
        self.textbox.selectAll()
        self.textbox.setMinimumWidth(200)

        self.queryButton = QPushButton("&Query")
        self.connect(self.queryButton, SIGNAL('clicked()'), self.onSubmitQuery)

        self.fwdButton = QPushButton("&>>")
        self.connect(self.fwdButton, SIGNAL('clicked()'), self.onFwd)

        self.bwdButton = QPushButton("&<<")
        self.connect(self.bwdButton, SIGNAL('clicked()'), self.onBwd)

        self.alignButton = QPushButton("&Close")
        self.connect(self.alignButton, SIGNAL('clicked()'), self.onFinish)

        self.grid_cb = QCheckBox("Show &Grid")
        self.grid_cb.setChecked(False)
        # self.connect(self.grid_cb, SIGNAL('stateChanged(int)'), self.onGrid)

        self.isAcceptedCB = QCheckBox("Accept?")
        self.isAcceptedCB.setChecked(False)
        self.connect(self.isAcceptedCB, SIGNAL('stateChanged(int)'), self.onChangeIsAccepted)
        
        slider_label = QLabel('Bar width (%):')
        self.slider = QSlider(Qt.Horizontal)
        self.slider.setRange(1, 100)
        self.slider.setValue(20)
        self.slider.setTracking(True)
        self.slider.setTickPosition(QSlider.TicksBothSides)

        # self.connect(self.slider, SIGNAL('valueChanged(int)'), self.onSlider)

        #
        # Layout with box sizers
        #
        hbox = QHBoxLayout()

        for w in [self.textbox, self.queryButton,self.isAcceptedCB, 
                  self.bwdButton, self.fwdButton, self.alignButton,
                  self.grid_cb, slider_label, self.slider]:
            hbox.addWidget(w)
            hbox.setAlignment(w, Qt.AlignVCenter)

        vbox = QVBoxLayout()
        vbox.addWidget(self.canvas)
        vbox.addWidget(self.mpl_toolbar)
        vbox.addLayout(hbox)

        self.main_frame.setLayout(vbox)
        self.setCentralWidget(self.main_frame)

    def drawCurrTrial(self):
        self.fig.clear()
        self.fig.hold(True)
        self.ax1 = self.fig.add_subplot(211)
        self.ax2 = self.fig.add_subplot(212)

        self.ax1.plot(self.currTrial['Left Shoulder Flex / Time'])
        self.ax1.set_ylim([20, 120])
        self.ax2.plot(self.currTrial['Biceps'])
        self.ax2.set_ylim([-1.0, 1.0])
                
        ### Draw timeOnset lines
        self.onsetLine1 = self.ax1.axvline(x=self.currOnset(), ymin=0, ymax=100, color='b', linewidth=5)
        self.onsetLine2 = self.ax2.axvline(x=self.currOnset(), ymin=0, ymax=100, color='r', linewidth=5)

        
        self.canvas.draw()
    
    def currOnset(self):
       return self.allQueryResults[self.idList[self.currTrialNum]]['timeOnset']


    def setOnset(self):
        """Add the field 'onset' to all documents"""
        l = self.currTrial['Left Shoulder Flex / Time'][0:800]
        base = sum(l) / float(len(l))
        th = base * 0.98
        f = lambda x: x <= th
        
        possible = indices(f, self.currTrial['Left Shoulder Flex / Time'])
        tOnset = possible[0]
        self.allOnsets[self.currTrialNum] = tOnset
        self.allQueryResults[self.idList[self.currTrialNum]]['timeOnset'] = int(tOnset)
#        self.allAlignedTrials[self.currTrialNum] = self.currTrial.drop(xrange(self.currOnset - 100))
        
    def setPickedOnsetLine(self, artist):
        self.onsetLine1 = artist
        self.onsetLine1.set_color('g')
                
    def setCurrTrial(self, n=0):
        self.currTrialNum = n
        # print(len(self.allTrials))
        # self.currTrial = self.allTrials[self.currTrialNum]
        self.currTrial = self.allQueryResults[self.idList[n]]['trialData']
        # print(self.currTrialNum, len(self.currTrial))
        self.isAcceptedCB.setChecked(self.allQueryResults[self.idList[n]]['isAccepted'])
        self.setOnset()

    def setOnsetLine(self, new_x):
        xs, ys = self.onsetLine1.get_data()
        #new_xs = [min(rbound, max(lbound, new_x)) for xx in xs]
        self.onsetLine1.set_data(new_x, ys)
        self.onsetLine2.set_data(new_x, ys)
        self.allQueryResults[self.idList[self.currTrialNum]]['timeOnset'] = new_x
        self.canvas.draw()

    def onPick(self, event):
        self.setPickedOnsetLine(event.artist)
        self.canvas.draw()

    def onMouseDown(self, event):
        self.isDragging = True

    def onMouseUp(self, event):
        self.isDragging = False

    def onMouseMotion(self, event):
        if self.isDragging:
            self.setOnsetLine(event.xdata)
            
    def onKey(self, event):
        if event.key in '[':
            xs, ys = self.onsetLine1.get_data()
            new_xs = [xx - 20 for xx in xs]
            self.onsetLine1.set_data(new_xs, ys)
        elif event.key in ']':
            xs, ys = self.onsetLine1.get_data()
            new_xs = [xx + 20 for xx in xs]
            self.onsetLine1.set_data(new_xs, ys)
        elif event.key in '{':
            xs, ys = self.onsetLine1.get_data()
            new_xs = [xx - 100 for xx in xs]
            self.onsetLine1.set_data(new_xs, ys)
        elif event.key in '}':
            xs, ys = self.onsetLine1.get_data()
            new_xs = [xx + 100 for xx in xs]
            self.onsetLine1.set_data(new_xs, ys)
        self.canvas.draw()

    def onFwd(self):
        """Go forward 1 trial"""
        self.setCurrTrial(min(self.currTrialNum + 1, self.numTrials - 1))
        self.drawCurrTrial()
        # self.setOnset()
        # self.setOnsetLine()

    def onBwd(self):
        """Go backward 1 trial"""
        self.setCurrTrial(max(self.currTrialNum - 1, 0))
        self.drawCurrTrial()
        # self.setOnset()
        # self.setOnsetLine()
    
    def onChangeIsAccepted(self, value):            
        self.allQueryResults[self.idList[self.currTrialNum]]['isAccepted'] = \
            True if value == 2 else False
        
    def onFinish(self):
        # self.freezeAllOnsets()
        self.freezeAllQueryResults()
        self.close()

    def onSubmitQuery(self):
        self.queryData(str(self.textbox.toPlainText()))
        self.setCurrTrial()
        
        self.drawCurrTrial()
        # self.setOnset()
        # self.setOnsetLine()


def main():
    app = QApplication(sys.argv)

    # myFreezer = Freezer('mongodb://diophantus.usc.edu:27017/')
    myFreezer = Freezer('mongodb://localhost:27017/')

    cadWatcher = Watcher(myFreezer)

    cadWatcher.show()
    app.exec_()


if __name__ == "__main__":
    main()
