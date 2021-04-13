begin
tfiles = systemfunc("ls *.tar")
do nn = 0, dimsizes(tfiles)-1

; print("tar -xvf "+tostring(tfiles(nn)))
system("tar -xvf "+tfiles(nn))
end do 
end
