# QuickVote

Project status: suspended

This project is for building an easy-to-use and quick voting app based on the iOS MultipeerConnectivity technology (https://developer.apple.com/documentation/multipeerconnectivity).

However, a technical limitation of `MCSession` is found out after the project started: "Sessions currently support up to 8 peers, including the local peer." Since this quick voting app should be capable of supporting a reasonable number of users (~20), this project has to move on without using the MultipeerConnectivity technology. 
