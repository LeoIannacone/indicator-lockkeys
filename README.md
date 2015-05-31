![logo.png](http://i.imgur.com/wqRFty2.png)

This is just another indicator for **Lock Keys** with fancy
icons which can enable and disable **Caps Lock** and **Num Lock**
directly from the **Graphical User Interface**.


## Installation via ppa

Use the following ppa:
```
sudo add-apt-repository ppa:l3on/indicator-lockkeys
sudo apt-get update
sudo apt-get install indicator-lockkeys
```

Then exec `indicator-lockkeys` from command-line or logout and login
in Unity again.

## Manually

Install the deps:
```
sudo apt-get install valac libgtk-3-dev libappindicator3-dev libcaribou-dev libgtk-3-bin
```

Build and install system wide:
```
make
sudo make install
```
