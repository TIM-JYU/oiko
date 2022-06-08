import multiprocessing

bind = "0.0.0.0:5000"
workers = 4 # We don't that many processes in general as Oiko is generally an internal API