#tag Class
Protected Class iCalMiniCalendar
Inherits Canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  dim therow As integer
		  dim thecolumn As integer
		  
		  
		  if y > headerbreak + 1 then
		    thecolumn=ceil(x/daywidth)
		    therow=ceil((y - headerbreak)/dayheight)
		    selectednumber=dategrid(thecolumn,therow)
		    dateselected(currentmonth,selectednumber,currentyear)
		  end if
		  
		  
		  if x >= me.width/7/2 - 5 and x <= me.width/7/2 + 5 and y >= 10 and y <= 20 then '----- left nav button
		    me.currentmonth=me.currentmonth - 1
		    if me.currentmonth<1 then
		      me.currentmonth=12
		      me.currentyear=me.currentyear - 1
		    end if
		  elseif x >= me.width/7/2 + me.width/7 * 6 - 5 and x <= me.width/7/2 + me.width/7 * 6 + 5 and y >= 10 and y <= 20 then '----- right nav button
		    me.currentmonth= me.currentmonth + 1
		    if me.currentmonth>12 then
		      me.currentmonth=1
		      me.currentyear=me.currentyear + 1
		    end if
		  end if
		  
		  self.refresh
		  return true
		End Function
	#tag EndEvent

	#tag Event
		Function MouseWheel(X As Integer, Y As Integer, deltaX as Integer, deltaY as Integer) As Boolean
		  //Commented out EJ 07/24/14 -----
		  'if deltay < 0 then
		  'deltay = -1
		  'me.currentmonth= me.currentmonth + 1
		  'if me.currentmonth>12 then
		  'me.currentmonth=1
		  'me.currentyear=me.currentyear + 1
		  'end if
		  'elseif deltay > 0 then
		  'deltay = 1
		  'me.currentmonth=me.currentmonth - 1
		  'if me.currentmonth<1 then
		  'me.currentmonth=12
		  'me.currentyear=me.currentyear - 1
		  'end if
		  'end if
		  'me.refresh
		  // -----
		End Function
	#tag EndEvent

	#tag Event
		Sub Open()
		  dim thedate As date
		  dim theday As integer
		  dim themonth As integer
		  dim theyear As integer
		  dim thedayofweek As integer
		  dim tempstring As string
		  dim j As integer
		  
		  loadpics
		  
		  //set all the default values
		  thedate=new date
		  me.currentday=thedate.day
		  me.currentmonth=thedate.month
		  me.currentyear=thedate.year
		  months(1)="January"
		  months(2)="February"
		  months(3)="March"
		  months(4)="April"
		  months(5)="May"
		  months(6)="June"
		  months(7)="July"
		  months(8)="August"
		  months(9)="September"
		  months(10)="October"
		  months(11)="November"
		  months(12)="December"
		  textsize=11
		  selectednumber=0
		  textfont=""
		  open
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  
		  BuildiCalCalendar(currentday,currentmonth,currentyear,g)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Sub BuildiCalCalendar(theday as integer, themonth as integer, theyear as integer, g as graphics)
		  
		  dim tempstring As string
		  dim j,i,n,m,k,x,thedaytoday,temp2,drawy,todaysdate,gridrow,tempnum,todayleft,todaytop,lastdayrow,lastdaycolumn As integer
		  dim tempdate As date
		  dim tempdayofweek As integer
		  dim points(6) As integer
		  dim dayletters(7) As string
		  
		  dim d as new date
		  
		  
		  'this is a drawing routine - pass it to the paint event
		  for j=0 to 7
		    for k=0 to 6
		      dategrid(j,k)=0
		    next
		  next
		  
		  g.textfont="Helvetica Neue"
		  
		  tempdate=new date
		  tempdate.day=1
		  tempdate.month=themonth
		  tempdate.year= me.currentyear
		  tempdayofweek=tempdate.dayofweek
		  ' days are going to be square so we use the lesser of the length and width to determine day size
		  g.ForeColor = &cC6CAD2
		  g.fillrect 0,0,g.width,g.height
		  
		  'get a sense of the breakdown of the canvas
		  drawy = headerbgpic.height + 1
		  n = g.height - drawy
		  if n MOD 6 = 0 then
		  else
		    while n MOD 6 <> 0
		      n = n - 1
		      drawy = drawy + 1
		    wend
		  end if
		  
		  headerbreak = drawy
		  dayheight = (g.height - drawy)/6
		  daywidth = g.width/7
		  'draw the header background
		  g.DrawPicture headerbgpic,0,1,g.width,headerbreak,0,0,headerbgpic.width,headerbgpic.height
		  //add the nav arrows
		  
		  g.foreColor=&cF6F6F6
		  //set text size
		  g.textsize = 13
		  //set the month
		  tempstring=MonthName(themonth) + " " + str(tempdate.year)
		  g.bold=true
		  n = g.stringwidth(tempstring)
		  g.drawstring tempstring,g.width/2 - n/2,21
		  g.foreColor= &c424242
		  g.drawstring tempstring,g.width/2 - n/2,20
		  //set the year
		  
		  //draw the letters for the days
		  g.foreColor=&cF6F6F6
		  g.TextSize = 9
		  n = g.width/7/2
		  m = g.StringWidth("Sun")
		  g.drawstring "Sun",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Sun",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7
		  m = g.StringWidth("Mon")
		  g.drawstring "Mon",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Mon",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7 * 2
		  m = g.StringWidth("Tue")
		  g.drawstring "Tue",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Tue",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7 * 3
		  m = g.StringWidth("Wed")
		  g.drawstring "Wed",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Wed",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7 * 4
		  m = g.StringWidth("Thu")
		  g.drawstring "Thu",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Thu",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7 * 5
		  m = g.StringWidth("Fri")
		  g.drawstring "Fri",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Fri",n - m/2,headerbreak - 5
		  g.foreColor=&cF6F6F6
		  n = g.width/7/2 + g.width/7 * 6
		  m = g.StringWidth("Sat")
		  g.drawstring "Sat",n - m/2,headerbreak - 4
		  g.foreColor= &c424242
		  g.drawstring "Sat",n - m/2,headerbreak - 5
		  
		  g.TextSize = 14
		  
		  'draw the grid
		  for i = 1 to 6
		    g.ForeColor = &ca1abba
		    g.drawline i * daywidth,headerbreak + 1,i * daywidth,g.height - 1 'vertical
		    g.ForeColor = &cd8d9df
		    g.drawline i * daywidth + 1,headerbreak + 1,i * daywidth + 1,g.height - 1 'vertical
		    g.ForeColor = &ca1abba
		    g.drawline 1,headerbreak + (i -1) * dayheight,g.width - 1,headerbreak + (i - 1) * dayheight
		    g.ForeColor = &Cd6d6dd
		    g.drawline 1,headerbreak + (i - 1) * dayheight + 1,g.width - 1,headerbreak + (i - 1) * dayheight + 1
		  next
		  
		  //draw in the dates
		  tempnum=tempdayofweek
		  'this is possibly going to leave a number of days from the prior month in the first row.
		  if tempnum > 1 then 'there you go
		    drawy = drawy + dayheight/2 + g.TextSize/2 - 2
		    if currentmonth > 1 then
		      x = getlastday(currentmonth - 1,currentyear)
		    else
		      x = getlastday(12,currentyear - 1)
		    end if
		    for i = 1 to tempnum - 1
		      '----- draw the lighter background to the cells
		      g.forecolor = &cd9dde4
		      if i = 1 then
		        g.fillrect (i - 1) * daywidth + 1,headerbreak + 2,daywidth - 1,dayheight - 2
		      else
		        g.fillrect (i - 1) * daywidth + 2,headerbreak + 2,daywidth - 2,dayheight - 2
		      end if
		      
		      n = g.StringWidth(str(x - (tempnum - i) + 1))
		      g.foreColor= &cF6F6F6
		      g.drawstring str(x - (tempnum - i) + 1),(daywidth*i)-daywidth/2 - n/2,drawy + 1 'shadow
		      g.foreColor= &cb3b3b3
		      g.drawstring str(x - (tempnum - i) + 1),(daywidth*i)-daywidth/2 - n/2,drawy 'actual
		    next
		  end if
		  if mondaystart then
		    tempnum=tempnum-1
		    if tempnum=0 then
		      tempnum=7
		    end if
		  end if
		  thedaytoday=0
		  temp2=DaysOfMonth(themonth,theyear)
		  if drawy = headerbreak then
		    drawy= drawy + dayheight/2 + g.TextSize/2 - 2
		  end if
		  gridrow=1
		  do
		    for j=tempnum to 7
		      thedaytoday=thedaytoday+1
		      if thedaytoday>temp2 then
		        exit
		      end if
		      dategrid(j,gridrow)=thedaytoday
		      'highlight today
		      if thedaytoday = theday and currentmonth = d.month and currentyear = d.year then
		        todayleft = daywidth * (j - 1) + 1
		        todaytop = headerbreak + dayheight * (gridrow - 1)
		        g.ForeColor = &c597299
		        g.fillrect todayleft - 1,todaytop,daywidth + 1,dayheight + 1
		        'handle the shadow
		        g.DrawPicture shadowul,todayleft - 1,todaytop
		        g.DrawPicture shadowur,todayleft + daywidth - shadowur.width,todaytop
		        g.DrawPicture shadowll,todayleft - 1,todaytop + dayheight - shadowll.height
		        g.DrawPicture shadowlr,todayleft + daywidth - shadowlr.width,todaytop + dayheight - shadowlr.height
		        
		        g.DrawPicture shadowleft,todayleft - 1,todaytop + shadowul.height,shadowleft.width,dayheight - shadowul.height - shadowll.height,0,0,shadowleft.width,shadowleft.height
		        g.DrawPicture shadowtop,todayleft - 1 + shadowul.width,todaytop,daywidth - shadowul.width - shadowur.width + 1,shadowtop.height,0,0,shadowtop.width,shadowtop.height
		        g.DrawPicture shadowright,todayleft + daywidth - shadowright.width,todaytop + shadowur.height,shadowright.width,dayheight - shadowur.height - shadowlr.height,0,0,shadowright.width,shadowright.height
		        g.DrawPicture shadowbottom,todayleft - 1 + shadowll.width,todaytop + dayheight - shadowll.height,daywidth - shadowll.width - shadowlr.width + 1,shadowbottom.height,0,0,shadowbottom.width,shadowbottom.height
		      end if
		      'highlight the selected day
		      if thedaytoday=selectednumber then
		        g.DrawPicture hilightpic,daywidth * (j - 1) + 1,headerbreak + dayheight * (gridrow - 1),daywidth,dayheight + 1,0,0,hilightpic.width,hilightpic.height
		        g.ForeColor = &C596994
		        g.DrawLine daywidth * (j - 1),headerbreak + dayheight * (gridrow - 1),daywidth * (j - 1) + daywidth,headerbreak + dayheight * (gridrow - 1) 'top
		        g.ForeColor = &C566590
		        g.drawline daywidth * (j - 1),headerbreak + dayheight * (gridrow - 1),daywidth * (j - 1),headerbreak + dayheight * (gridrow - 1) + dayheight 'left
		        g.ForeColor = &C687496
		        g.drawline daywidth * (j - 1) + daywidth,headerbreak + dayheight * (gridrow - 1),daywidth * (j - 1) + daywidth,headerbreak + dayheight * (gridrow - 1) + dayheight 'right
		        g.ForeColor = &C546592  'bottom
		        g.drawline daywidth * (j - 1),headerbreak + dayheight * (gridrow - 1) + dayheight,daywidth * (j - 1) + daywidth,headerbreak + dayheight * (gridrow - 1) + dayheight
		      end if
		      
		      n = g.StringWidth(str(thedaytoday))
		      if thedaytoday = theday and currentmonth = d.month and currentyear = d.year then
		        g.foreColor=&c424242
		      elseif thedaytoday = selectednumber then 'bevel text color
		        g.foreColor=&c424242
		      else
		        g.foreColor=&cF6F6F6
		      end if
		      g.drawstring str(thedaytoday),(daywidth*j)-daywidth/2 - n/2,drawy + 1
		      if thedaytoday = theday and currentmonth = d.month and currentyear = d.year then
		        g.foreColor= &CFFFFFF
		      elseif thedaytoday = selectednumber then 'text color
		        g.foreColor= &CFFFFFF
		      else
		        g.foreColor= &c4E4E4E
		      end if
		      g.drawstring str(thedaytoday),(daywidth*j)-daywidth/2 - n/2,drawy
		    next
		    tempnum=1 'this resets the column after each week.
		    gridrow=gridrow+1
		    drawy=drawy+dayheight
		  loop until(thedaytoday>=temp2)
		  '----- handle the dates in the next month, if we have need
		  lastdayrow = gridrow
		  lastdaycolumn = j
		  thedaytoday = 0
		  tempnum = lastdaycolumn
		  if tempnum <> 0 then
		    gridrow = gridrow - 1
		    drawy=drawy - dayheight
		  end if
		  do
		    for j = tempnum to 7
		      thedaytoday=thedaytoday+1
		      n = g.StringWidth(str(thedaytoday))
		      'handle the background color
		      g.ForeColor = &cd0d4db
		      if j = 1 then
		        g.fillrect (j - 1) * daywidth + 1,headerbreak + 2 + (gridrow - 1) * dayheight,daywidth - 1,dayheight - 2
		      else
		        g.fillrect (j - 1) * daywidth + 2,headerbreak + 2 + (gridrow - 1) * dayheight,daywidth - 2,dayheight - 2
		      end if
		      g.foreColor= &cF6F6F6
		      g.drawstring str(thedaytoday),(daywidth*j)-daywidth/2 - n/2,drawy + 1 'shadow
		      g.foreColor= &cb3b3b3
		      g.drawstring str(thedaytoday),(daywidth*j)-daywidth/2 - n/2,drawy 'actual
		    next
		    tempnum=1 'this resets the column after each week.
		    gridrow=gridrow+1
		    drawy=drawy+dayheight
		  loop until gridrow = 7
		  
		  '----- left nav button
		  g.ForeColor = &cF6F6F6
		  n = g.width/7/2
		  points(1) = n - 5
		  points(2) = 15
		  points(3) = n + 5
		  points(4) = 10
		  points(5) = n + 5
		  points(6) = 20
		  g.FillPolygon points
		  g.ForeColor = &c4E4E4E
		  points(1) = n - 5
		  points(2) = 14
		  points(3) = n + 5
		  points(4) = 9
		  points(5) = n + 5
		  points(6) = 19
		  g.FillPolygon points
		  '----- right nav button
		  g.ForeColor = &cF6F6F6
		  n = g.width/7/2 + g.width/7 * 6
		  points(1) = n + 5
		  points(2) = 15
		  points(3) = n - 5
		  points(4) = 10
		  points(5) = n - 5
		  points(6) = 20
		  g.FillPolygon points
		  g.ForeColor = &c4E4E4E
		  points(1) = n + 5
		  points(2) = 14
		  points(3) = n - 5
		  points(4) = 9
		  points(5) = n - 5
		  points(6) = 19
		  g.FillPolygon points
		  
		  g.foreColor=&cABABAB
		  g.DrawRect 0,0,g.width,g.height
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DaysOfMonth(month As integer, year As integer) As Integer
		  dim tempnum As integer
		  
		  
		  select case month
		  case 1
		    return 31
		  case 2
		    tempnum=year mod 4
		    if tempnum=0 then
		      return 29
		    else
		      return 28
		    end if
		  case 3
		    return 31
		  case 4
		    return 30
		  case 5
		    return 31
		  case 6
		    return 30
		  case 7
		    return 31
		  case 8
		    return 31
		  case 9
		    return 30
		  case 10
		    return 31
		  case 11
		    return 30
		  case 12
		    return 31
		  else
		    return 0
		  end select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getlastday(inmonth as integer, inyear as integer) As Integer
		  
		  if inmonth = 1 then
		    return 31
		  elseif inmonth = 2 then
		    if inyear mod 4 = 0 then 'leap year
		      return 29
		    else
		      return 28
		    end if
		  elseif inmonth = 3 then
		    return 31
		  elseif inmonth = 4 then
		    return 30
		  elseif inmonth = 5 then
		    return 31
		  elseif inmonth =6 then
		    return 30
		  elseif inmonth =7 then
		    return 31
		  elseif inmonth =8 then
		    return 31
		  elseif inmonth =9 then
		    return 30
		  elseif inmonth = 10 then
		    return 31
		  elseif inmonth = 11 then
		    return 30
		  elseif inmonth = 12 then
		    return 31
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getSelectedDate() As string
		  //This method will return the date of the selected number in form YearMonthDay ex. 20140121
		  //@return: The date
		  
		  return str(currentyear) + Format(currentmonth, "0#") + Format(selectednumber, "0#") 
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub loadpics()
		  dim s as string
		  dim thearray(-1) as string
		  dim i,n,j,width,height as integer
		  dim c as color
		  
		  'header pic
		  s = bgpic
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  headerbgpic  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    headerbgpic.RGBSurface.Pixel(j,n) = c
		  next
		  
		  'highlight pic
		  s = highlightpic
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  hilightpic  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    hilightpic.RGBSurface.Pixel(j,n) = c
		  next
		  
		  'thedaytoday mask
		  s = kleftshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowleft  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowleft.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = krightshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowright  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowright.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = ktopshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowtop  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowtop.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = kbottomshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowbottom  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowbottom.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = ktopleftshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowul  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowul.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = ktoprightshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowur  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowur.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = kbottomleftshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowll  = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowll.RGBSurface.Pixel(j,n) = c
		  next
		  
		  s = kbottomrightshade
		  thearray = s.split("|")
		  width = val(thearray(0))
		  height = val(thearray(1))
		  shadowlr = New Picture(width,height,32)
		  thearray = thearray(2).split(",")
		  for i = 0 to width * height - 1
		    j = i mod width
		    n = floor(i/width)
		    c = rgb(val(left(thearray(i),3)),val(mid(thearray(i),4,3)),val(right(thearray(i),3)))
		    shadowlr.RGBSurface.Pixel(j,n) = c
		  next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MonthName(month As integer) As String
		  if month>=1 and month<=12 then
		    return months(month)
		  else
		    return ""
		  end if
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DateSelected(Month as integer,Day as integer,Year as integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook


	#tag Note, Name = General_Comments
		1)  
		2) You will need to handle text size of you want to make the calendar much larger.  Also, the header area is presently limited by the height of the header pic, so you would have to handle that also.
		3) To derive a date from the calendar, use currentmonth, selectednumber, currentyear
		4) Rick Praetzel 2010
		
		Optimal Canvas size:182 x 188
	#tag EndNote


	#tag Property, Flags = &h0
		currentday As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		currentmonth As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		currentyear As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dategrid(7,6) As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dayheight As double
	#tag EndProperty

	#tag Property, Flags = &h0
		daywidth As double
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected headerbgpic As picture
	#tag EndProperty

	#tag Property, Flags = &h0
		headerbreak As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected hilightpic As picture
	#tag EndProperty

	#tag Property, Flags = &h0
		mondaystart As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		months(13) As string
	#tag EndProperty

	#tag Property, Flags = &h0
		selectednumber As integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowbottom As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowleft As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowLL As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowLR As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowright As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowtop As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowUL As picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected shadowUR As picture
	#tag EndProperty

	#tag Property, Flags = &h0
		textfont As string
	#tag EndProperty

	#tag Property, Flags = &h0
		textsize As integer
	#tag EndProperty

	#tag Property, Flags = &h0
		weekdays As string
	#tag EndProperty


	#tag Constant, Name = bgpic, Type = String, Dynamic = False, Default = \"1|36|234236241\x2C233235240\x2C230234239\x2C230234239\x2C230232237\x2C228231237\x2C226231236\x2C225230236\x2C224229235\x2C223227235\x2C222226234\x2C220225232\x2C220225232\x2C219224231\x2C217223230\x2C217223230\x2C216221229\x2C214220229\x2C213219228\x2C214220229\x2C214220229\x2C214220229\x2C213219228\x2C213219228\x2C213219228\x2C214220229\x2C213219228\x2C213219228\x2C214220229\x2C212218226\x2C213219228\x2C213219228\x2C212218226\x2C212218226\x2C212218226\x2C211216225", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = highlightpic, Type = String, Dynamic = False, Default = \"1|25|067086131\x2C150200246\x2C097173241\x2C088166240\x2C078162238\x2C068156237\x2C058152237\x2C047146236\x2C035139235\x2C022136233\x2C016129231\x2C015125231\x2C013112227\x2C011097224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C011098224\x2C063083131", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kbottomleftshade, Type = String, Dynamic = False, Default = \"4|4|055077108\x2C071101141\x2C075109152\x2C080112160\x2C054075104\x2C068097137\x2C071104145\x2C075109154\x2C049069098\x2C064091127\x2C068097137\x2C071101141\x2C047064090\x2C058081115\x2C061087122\x2C063090126", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kbottomrightshade, Type = String, Dynamic = False, Default = \"4|4|079112158\x2C074107151\x2C070098137\x2C074093119\x2C075108151\x2C071103144\x2C066093133\x2C073090117\x2C070101141\x2C067095135\x2C063087123\x2C071087113\x2C063089125\x2C061086120\x2C057079112\x2C069082106", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kbottomshade, Type = String, Dynamic = False, Default = \"1|4|082117164\x2C080111157\x2C074104147\x2C065091129", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kleftshade, Type = String, Dynamic = False, Default = \"4|1|055076106\x2C072100141\x2C074107150\x2C079110159", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = krightshade, Type = String, Dynamic = False, Default = \"4|1|078111156\x2C074106150\x2C069096136\x2C074092118", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ktopleftshade, Type = String, Dynamic = False, Default = \"4|4|026034046\x2C028038051\x2C029040054\x2C029040055\x2C033045063\x2C039053073\x2C040056076\x2C042058081\x2C045063088\x2C057080114\x2C061088124\x2C063091126\x2C054076106\x2C071100140\x2C075108150\x2C079110159", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ktoprightshade, Type = String, Dynamic = False, Default = \"4|4|029040055\x2C028039052\x2C028037051\x2C052061074\x2C042058081\x2C040055076\x2C038052071\x2C059069088\x2C063090127\x2C061085121\x2C056079112\x2C068082106\x2C077110156\x2C074106150\x2C070097136\x2C074092118", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ktopshade, Type = String, Dynamic = False, Default = \"1|4|030042057\x2C044060083\x2C066093130\x2C080116162", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentday"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentmonth"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="currentyear"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="dayheight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="daywidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="headerbreak"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group=""
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mondaystart"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="selectednumber"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="textfont"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="textsize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="weekdays"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
