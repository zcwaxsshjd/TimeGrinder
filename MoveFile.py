import os
import uuid
import shutil
path_root = 'D:\\S2_L_forward_reaching'

if __name__ == '__main__':
    path = path_root
    files = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) if not f.startswith('.')]
    for f in files:
        fullname = os.path.abspath(os.path.join(path, f))
        print('Processing "%s"' % (f))
        u = str(uuid.uuid1())
        os.mkdir('./DataForS2/'+u)
        shutil.copyfile(fullname, './DataForS2/'+u+'/'+f)
