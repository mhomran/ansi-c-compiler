from PyQt5 import QtWidgets
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtGui import QFont, QPixmap
from PyQt5.QtWidgets import QPlainTextEdit, QScrollArea

import sys
from os import system, path

class CompilerWin(QMainWindow):
  def __init__(self) -> None:
    super(CompilerWin, self).__init__()
    xpos = 500
    ypos = 500
    width = 600
    height = 450

    self.setGeometry(xpos, ypos, width, height)
    self.setWindowTitle("Compiler")

    self.init_ui()

  def init_ui(self):
    self.Title = QtWidgets.QLabel(self)
    self.Title.setText("Please choose the input file")
    self.Title.move(50, 20)
    custom_font = QFont()
    custom_font.setWeight(80)
    custom_font.setPixelSize(30)
    QApplication.setFont(custom_font, "QLabel")
    self.Title.setFont(custom_font)
    self.Title.adjustSize()
  
    self.b_browse = QtWidgets.QPushButton(self)
    self.b_browse.setText("browse and compile")
    self.b_browse.clicked.connect(self.browse)
    custom_font.setPixelSize(15)
    self.b_browse.setFont(custom_font)
    self.b_browse.move(50, 100)
    self.b_browse.adjustSize()

    self.status = QPlainTextEdit(self)
    self.status.setFont(custom_font)
    self.status.move(50, 200)
    self.status.adjustSize()
    self.status.setFixedSize(500, 200)
    self.status.setReadOnly(True)

    self.SymTableImg = QtWidgets.QLabel(self)
    self.SymTableImg.move(600, 80)

    self.scrollArea = QScrollArea()
    self.scrollArea.setWidget(self.SymTableImg)
    self.scrollArea.setVisible(False)
    self.scrollArea.setWindowTitle("Symbol Table")

  def browse(self):
    file_path, _ = QtWidgets.QFileDialog.getOpenFileName(self, 
    'Pick the test file', "../test" , '*.c')
    if file_path:
      test_path = path.dirname(file_path)
      file_name = path.basename(file_path)
      root_path = f"{test_path}/.."
      
      system(f"cd {root_path} && make show_sym INPUT={file_name}")

      self.status.clear()
      f = open(f"{root_path}/build/warnings.txt", "r")
      self.status.insertPlainText("warnings:\n")
      self.status.insertPlainText(f.read())
      f.close()
      f = open(f"{root_path}/build/errors.txt", "r")
      self.status.insertPlainText("\nerrors:\n")
      self.status.insertPlainText(f.read())
      f.close()

      imagePath = f"{root_path}/build/symtable.dot.png"
      pixmap = QPixmap(imagePath)
      self.SymTableImg.setPixmap(pixmap)
      self.SymTableImg.resize((pixmap.size()))
      self.scrollArea.setFixedWidth(pixmap.size().width() * 2)
      self.scrollArea.setFixedHeight(self.height())
      self.scrollArea.setVisible(True)

  def closeEvent(self, event):
    self.scrollArea.setVisible(False)
    
    super(QMainWindow, self).closeEvent(event)

def window():
  app = QApplication(sys.argv)
  win = CompilerWin()

  win.show()
  sys.exit(app.exec_())

window()