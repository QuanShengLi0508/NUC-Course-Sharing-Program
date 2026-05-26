            		Sentinel System Driver 7.1.0
                             README.TXT File
              Copyright (c) 1991-2004 SafeNet Inc. 
                          All Rights Reserved

 Thank you for choosing Sentinel System Driver for x64 machines from SafeNet Inc.
 
 This README file provides information on product installation,
 new features, last-minute news, and where to go for more 
 information or to report problems.

-----------------------
 TABLE OF CONTENTS
-----------------------

  1.0 Supported Environments
  2.0 Installation Instructions
  3.0 Where to Go Next?
  4.0 Reporting Problems
 
----------------------------
 1.0 SUPPORTED ENVIRONMENTS
----------------------------

    *  Windows-XP Pro x64 Edition (RC1)
    *  Windows 2k3    x64 Edition (RC1)
    
 It was tested on the both the hardware platforms supporting x64 architecture:
 
 *  AMD64 from AMD 
 *  EM64T from Intel

-----------------------------
 2.0 Installation Instruction
-----------------------------

The Driver package has following Files / Directories :


a. Sentinel System Driver : This folder contains files needed for driver installation.

   1. SNTUSB64.inf	  : Inf File required for device installation on windows platform.

   2. SNTUSB64.sys 	  : USB driver binary

b. README.txt		  : This file.

To install the USB driver follow the instructions written below :

1. Plug the USB SuperPro / UltraPro key into the USB port. Windows' "New H/W found wizard" will ask for the driver       for the device.

2. Select "Install from a list or specific location (Advanced)" option from the wizard and go to next.

3. Now select "Don't search. I will choose the driver to install" option from the wizard and move to next.

4. Now click the Have Disk button and browse the system to provide the loaction of this package. (say,       "d:\SSP710_x64_USB_Driver\Sentinel System Driver") and click next.

5. A warning saying "This driver is not WHQL certified" will pop up, choose continue anyway as the driver is not WHQL    certified.

6. This will install the device driver for SafeNet USB dongle.


You can now run any SSP 631/SUP 100 32 bits Standalone Client application in the 64 bits machine. 

-------------------------
3.0 WHERE TO GO NEXT?
-------------------------

 Refer to the SuperPro / UltraPro Developer's guide for information on how to use
 the SuperPro / UltraPro key to protect your application.
 
-------------------------
 4.0 REPORTING PROBLEMS
-------------------------

 If you find any problems, please contact SafeNet Technical Support 
 using any of the following methods:

 CORPORATE HEADQUARTERS NORTH AMERICA AND SOUTH AMERICA
 ---------------------------------------------------------
 Internet      http://www.rainbow.com
 E-mail        techsupport@irvine.rainbow.com
 Telephone     (800) 959-9954 (Monday - Friday, 6:00 a.m.-6:00 p.m. PST)
 Fax           (949) 450-7450

 AUSTRALIA AND NEW ZEALAND
 ---------------------------------------------------------
 E-mail        techsupport@au.rainbow.com
 Telephone     (61) 3 9820 8900
 Fax           (61) 3 9820 8711

 CHINA
 ---------------------------------------------------------
 E-mail        sentinel@isecurity.com.cn
 Telephone     (86) 10 8266 3936
 Fax           (86) 10 8266 3948
 
 FRANCE
 ---------------------------------------------------------
 E-mail        EuTechSupport@rainbow.com
 Telephone     0825 341000
 Fax           +44 (0) 1932 570743

 GERMANY
 ---------------------------------------------------------
 E-mail        EuTechSupport@rainbow.com
 Telephone     0813 RAINBOW (7246269)
 Fax           +44 (0) 1932 570743

 TAIWAN AND SOUTHEAST ASIA
 ---------------------------------------------------------
 E-mail        techsupport@tw.rainbow.com
 Telephone     (886) 2 2570-5522
 Fax           (886) 2 2570-1988
 
 UNITED KINGDOM
 ---------------------------------------------------------
 E-mail        EuTechSupport@rainbow.com
 Telephone     0870 7529200
 Fax           +44 (0) 1932 570743
 
 OTHER COUNTRIES
 ---------------
 Customers not in countries listed above, please contact your local
 distributor.

[readme, 02/28/2005, V. 1]
