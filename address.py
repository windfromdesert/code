import sys
import cPickle as cP

def option():
    print '''use [add] to add a address.
use [edit] to edit a address.
use [del] to delete a address.
use [s] to search a address.
use [exit] to exit soft.'''
    return raw_input('please input a action specified:')

class addressbook:
    '''My addressbook.'''
    def add(self):
        global main
        name = raw_input('please input name:')
        company = raw_input('please input company:')
        ad = raw_input('please input address:')
        phone = raw_input('please input phone number:')
        email = raw_input('please input email:')
        im = raw_input('please input IM number:')
        value = {'company':company,'address':ad,'phone':phone,'email':email,'IM':im}
        data = open(addressfile).read()
        if len(data) >= 1:
            f = file(addressfile)
            main = cP.load(f)
            f.close()
        f = file(addressfile,'w')
        main[name] = value
        cP.dump(main,f)
        f.close()
    def edit(self):
        editname = raw_input('Please input a name for find the entry you want to modify:')
        f = file(addressfile)
        main = cP.load(f)
        if editname in main:
            svalue = main[editname]
            print 'name: '+editname
            print 'company: '+svalue['company']
            print 'address: '+svalue['address']
            print 'phone: '+svalue['phone']
            print 'email: '+svalue['email']
            print 'IM: '+svalue['IM']
        else:
            print 'no this name, please try again.'

running = True
main = {}
p = addressbook()
addressfile = 'g:/doc/myaddress'
if len(sys.argv) < 2:
    while running:
        a = option()
        if a == 'add':
            p.add()
        elif a == 'edit':
            p.edit()
        elif a == 's':
            p.search()
        elif a == 'exit':
            break
