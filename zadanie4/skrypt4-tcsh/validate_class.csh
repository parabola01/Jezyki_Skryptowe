#!/bin/tcsh

    set CLASS_A=(1 127)   # 1.0.0.0 127.0.0.0 
    set CLASS_B=(128 191) # 128.0.0.0 191.255.0.0 
    set CLASS_C=(192 223) # 192.0.0.0 223.255.255.0 
    set CLASS_D=(224 239) # 224.0.0.0 239.255.255.255
    set ip_1_parts=`echo "$1" | tr "." " "`
    set ip_2_parts=`echo "$2" | tr "." " "`

    if ( (`echo ${ip_1_parts[1]}` >= `echo ${CLASS_A[1]}`) && (`echo ${ip_1_parts[1]}` <= `echo ${CLASS_A[2]}`) ) then
		  set class_1 = "A"
    else if ( (`echo ${ip_1_parts[1]}` >= `echo ${CLASS_B[1]}`) && (`echo ${ip_1_parts[1]}` <= `echo ${CLASS_B[2]}`) ) then
		  set class_1 = "B"
    else if ( (`echo ${ip_1_parts[1]}` >= `echo ${CLASS_C[1]}`) && (`echo ${ip_1_parts[1]}` <= `echo ${CLASS_C[2]}`) ) then
		  set class_1 = "C"
    else if ( (`echo ${ip_1_parts[1]}` >= `echo ${CLASS_D[1]}`) && (`echo ${ip_1_parts[1]}` <= `echo ${CLASS_D[2]}`) ) then
		  set class_1 = "D"
    else 
      set class_1 = "E" 
    endif

    if ( (`echo ${ip_2_parts[1]}` >= `echo ${CLASS_A[1]}`) && (`echo ${ip_2_parts[1]}` <= `echo ${CLASS_A[2]}`) ) then
		  set class_2 = "A"
    else if ( (`echo ${ip_2_parts[1]}` >= `echo ${CLASS_B[1]}`) && (`echo ${ip_2_parts[1]}` <= `echo ${CLASS_B[2]}`) ) then
		  set class_2 = "B"
    else if ( (`echo ${ip_2_parts[1]}` >= `echo ${CLASS_C[1]}`) && (`echo ${ip_2_parts[1]}` <= `echo ${CLASS_C[2]}`) ) then
		  set class_2 = "C"
    else if ( (`echo ${ip_2_parts[1]}` >= `echo ${CLASS_D[1]}`) && (`echo ${ip_2_parts[1]}` <= `echo ${CLASS_D[2]}`) ) then
		  set class_2 = "D"
    else 
      set class_2 = "E" 
    endif

     if ( ($class_1 != $class_2) ) then
      exit 1
    else 
      exit 0
    endif