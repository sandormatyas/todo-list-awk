#!/bin/awk -f
BEGIN { FS=",";
	print "Options:";
	print "1 - list today's tasks";
	print "2 - list tomorrow's tasks";
	print "3 - list this week's tasks";
	print "4 - add task";
	print "5 - delete task";
	printf "Select an option: ";
	getline option < "-";

	"date +%Y-%m-%d" | getline today;
        "date --date=\"next day\" +%Y-%m-%d" | getline tomorrow;
	"date +%W" | getline this_week;

        if ( option == 4 ) {
	  printf "Enter new task: "
          getline task < "-";
	  printf "Enter due date: "
	  getline due_date < "-";
	  command="date -d " due_date " +%Y-%m-%d"
	  command | getline due_date
        } else if ( option == 5 ) {
	  system("touch .temp")
	  printf "Enter task you want to delete: "
	  getline id_to_delete < "-"
	}
}
{ if (option == 1 && today == $3) {
    print $2;
  } else if (option == 2 && tomorrow == $3) {
    print $2;
  } else if (option == 3) {
    command = "date -d " $3 " +%W"
    command | getline task_week
    if (this_week == task_week) {
    print $2;
    }
  } else if (option == 5 && $1 != id_to_delete) {
    print >> ".temp"
  }
}
END {
  if (option == 4) {
    print ++NR "," task "," due_date  >> FILENAME ## ++NR is NOT a good solution because if a row is deleted then you get duplicate ids
  } else if (option == 5) {
      command="cat .temp > " FILENAME
      system(command)
      system("rm .temp")
  }
}
