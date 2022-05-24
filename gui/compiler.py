from PyQt5 import QtWidgets, QtCore
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtGui import QFont

import sys
from os import system, path

class CompilerWin(QMainWindow):
  def __init__(self) -> None:
    super(CompilerWin, self).__init__()
    xpos = 500
    ypos = 500
    width = 300
    height = 100
    self.setGeometry(xpos, ypos, width, height)
    self.setWindowTitle("Compiler")

    self.init_ui()

  def init_ui(self):
    self.label = QtWidgets.QLabel(self)
    self.label.setText("Please choose the input file")
    self.label.move(50, 20)
    custom_font = QFont()
    custom_font.setWeight(80)
    custom_font.setPixelSize(15)
    QApplication.setFont(custom_font, "QLabel")
    self.label.setFont(custom_font)
    self.label.adjustSize()
  
    self.b_browse = QtWidgets.QPushButton(self)
    self.b_browse.setText("browse and compile")
    self.b_browse.clicked.connect(self.browse)
    self.b_browse.move(50, 50)
    self.b_browse.adjustSize()

  def browse(self):
    file_path, _ = QtWidgets.QFileDialog.getOpenFileName(self, 'Pick the test file', "../test" , '*.c')
    if file_path:
      print(file_path)
      file_name = path.basename(file_path)

      system(f"cd .. && make test INPUT={file_name}")

def window():
  app = QApplication(sys.argv)
  win = CompilerWin()

  # put some stuff



  win.show()
  sys.exit(app.exec_())

window()