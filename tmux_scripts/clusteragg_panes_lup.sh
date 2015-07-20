#! /bin/bash
tmux new-window 'ssh clusteragg-app1.lup1 -L 9111:localhost:9111'
# Make a pane below with 75% of the space
tmux split-window -p 66 'ssh clusteragg-app2.lup1 -L 9112:localhost:9111'
# Make a pane below with 66% of the space
tmux split-window -p 50 'ssh clusteragg-app3.lup1 -L 9113:localhost:9111'

# Start splitting horizontally, moving upwards
tmux split-window -h -p 50 'ssh clusteragg-app6.lup1 -L 9116:localhost:9111'
tmux select-pane -U

tmux split-window -h -p 50 'ssh clusteragg-app5.lup1 -L 9115:localhost:9111'
tmux select-pane -U

# Final horizontal split, then move left to leave cursor in top left pane.
tmux split-window -h -p 50 'ssh clusteragg-app4.lup1 -L 9114:localhost:9111'
tmux select-pane -L

sleep 1
open 'http://localhost:9111'
open 'http://localhost:9112'
open 'http://localhost:9113'
open 'http://localhost:9114'
open 'http://localhost:9115'
open 'http://localhost:9116'

open 'http://clusteragg-app1.lup1:7066/status'
open 'http://clusteragg-app2.lup1:7066/status'
open 'http://clusteragg-app3.lup1:7066/status'
open 'http://clusteragg-app4.lup1:7066/status'
open 'http://clusteragg-app5.lup1:7066/status'
open 'http://clusteragg-app6.lup1:7066/status'
