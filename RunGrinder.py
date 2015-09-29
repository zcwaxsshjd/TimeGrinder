__author__ = 'minosniu'
import sys
import os

path_root = 'D:\\S2_L_forward_reaching'

expt = 'FES_reaching'
date = '20150929'
analyst = 'zcwaxs'
addr = 'mongodb://localhost:27017/'
patient = 'CXM'
side = 'left'
movement = 'forward_reaching'

if __name__ == '__main__':
    path = path_root
    files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) if not f.startswith('.')]
    for f in files:
        fullname = os.path.abspath(os.path.join(path, f))
        print('Processing "%s"' % (f))
        print('python Grinder.py "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s"' % 
            (fullname, expt, date, analyst, addr, patient, side,movement))
        os.system('python Grinder.py "%s" "%s" "%s" "%s" "%s" "%s" "%s" "%s"' % 
            (fullname, expt, date, analyst, addr, patient, side,movement))

