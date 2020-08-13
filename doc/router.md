# RPI Sharing WiFi with ethernet connected equipmet
```
         ---------------------
  PC --> |eth0   RPI4    wifi| ---> internet
         ---------------------
```
I have used this in an instance where my fixed internet connection
went down and I wanted my ordinary router to still work and be able to use
the internet connection of my mobile phone.

```
      ----------------
      | Internal lan |
      ----------------
             |
      ----------------
      |    Router    |
      ----------------
             |
      ----------------
      | Raspberry Pi |
      ----------------
             |
          - wifi -

      ----------------
      | Mobile Phone |
      ----------------
             |
           - 4G -

      ----------------
      |   Internet   |
``` 
* Add `denyinterfaces eth0` to `/etc/dhcpcd.conf`
* Set up static ip using `/etc/network/interfaces.d/eth0`
```
auto eth0
allow-hotplug eth0
iface eth0 inet static
  address 10.56.0.1
  netmask 255.255.255.248
```
* Enable IPv4 routing by adding `/etc/sysctl.d/router.conf`
```
# Enable IPv4 routing
net.ipv4.ip_forward=1
```

* `apt install -y netfilter-persistent iptables-persistent`
* `sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE`
* `sudo netfilter-persistent save`





# Links
* https://www.raspberrypi.org/documentation/configuration/wireless/access-point-routed.md
