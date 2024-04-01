# pilsbot <a href="https://liberapay.com/pilsbot/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>
Automate your pils transportation!

lscode: [O+S++I!CE-MV---!PSD-](https://lscodes.pke.fyi/api/decode?q=O+S++IE-MV---!PSD-)

![lorry_prototype](https://github.com/pilsbot/pilsbot/assets/7480344/018a10a5-a013-4b19-a1f4-ab59de31ba23)


This project intends to build an autonomous lorry for transporting pils-beer and other beverages, while following its "flock" - us humans.
It does so by using cheap hoverboard-hub-motors and entry-level robotics equipment (i.e. a jetson nano, OAK-D stereo camera).
The driving is solved simply by measuing the steering angle and odometry along with a mixture of differential drive and ackermann steering, resulting in a new driver - ackerdiff (see https://github.com/pilsbot/pils_control) and the interface to the hoverboard (see https://github.com/pilsbot/pilsbot_hw_ros).

For installation, see [here](https://github.com/pilsbot/pilsbot/wiki/Installation) or [here](https://github.com/pilsbot/pilsbot_vscode_ws).
  
