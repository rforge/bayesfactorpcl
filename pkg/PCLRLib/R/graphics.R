#This file is for all R functions for plotting.


my.ps=function(file,width=7,height=7,panels=NULL)
{
if (length(panels)==2) 
{
height=5*panels[1]
width=5*panels[2]
}
postscript(file=file,horizontal = FALSE, onefile =FALSE, 
paper = "special",width=width,height=height)
}


#Create error bars on a plot. The function attempts to guess good values for the width of the bars.
errbar<-function(x,y,sd,xlen=-1,col=par("fg"),lwd=par("lwd"),lty=1,type=0){
  inperunx<-par('pin')[1]/(par('usr')[2]-par('usr')[1])
  inperuny<-par('pin')[2]/(par('usr')[4]-par('usr')[3])

  #automatically find a good width
  if(xlen==-1) xlen=min(inperunx*min(diff(x))/3,inperuny*min(sd/3))/inperunx
  xlenin<-xlen*inperunx
  #0 is both, 1 is upper, 2 is lower

  if(type%in%c(0,2)) arrows(x,y,x,y-sd,angle=90,col=col,lwd=lwd,lty=lty,length=xlenin/2)
  if(type%in%c(0,1)) arrows(x,y,x,y+sd,angle=90,col=col,lwd=lwd,lty=lty,length=xlenin/2)
  return(data.frame(xlen))
}

horiz.errbar=function(x,y,height,width,lty=1)
{
  arrows(x,y,x+width,y,angle=90,length=height,lty=lty)
  arrows(x,y,x-width,y,angle=90,length=height,lty=lty)
}



# Useful function to shade under a given function on a plot.
shade.under<-function(fn,range=c(-Inf,Inf),precision=100,addaxis=TRUE,border=NULL, density=NULL,angle=45,col=NULL,lty=NULL,xpd=NULL,redraw=FALSE,col.redraw=par('fg'), prec.redraw=NULL,lty.redraw=par('lty'),lwd.redraw=par('lwd'),...){
  range=range[1:2]
  if(range[2]<range[1]){range=rev(range)}
  if(range[1]==-Inf){
   range[1]=par('usr')[1]
  }
  if(range[2]==Inf){
   range[2]=par('usr')[2]
  }
  precision=diff(range)/precision
  x=seq(range[1],range[2],precision)
  y=fn(x,...)
  x1=c(x,rev(x))
  y1=c(y,y*0)
  polygon(x1,y1,border=border,density=density,angle=angle,col=col,lty=lty,xpd=xpd)
  if(redraw){
    if(is.null(prec.redraw)){
      x.redraw=seq(par('usr')[1],par('usr')[2],precision)
    }else{
      x.redraw=seq(par('usr')[1],par('usr')[2],diff(par('usr')[1:2])/prec.redraw)
    }
    lines(x.redraw,fn(x.redraw,...),col=col.redraw,lty=lty.redraw,lwd=lwd.redraw)
    if(addaxis){
     abline(h=0,col=par('fg'),lty=par('lty'))
    }
  }
}


draw.circle=function(xcen,ycen,radius,prec=7,...){
theta=seq(0,2*pi,len=2^floor(prec)+1)
y=radius*sin(theta)+ycen
x=radius*cos(theta)+xcen
polygon(x,y,...)
}

draw.double.circle=function(xcen,ycen,radius,ratio,prec=7,...){
draw.circle(xcen,ycen,radius*ratio,prec,...)
draw.circle(xcen,ycen,radius,prec,...)
}

draw.square=function(xcen,ycen,radius,...){
theta=seq(pi/4,9*pi/4,len=5)
y=sqrt(2)*radius*sin(theta)+ycen
x=sqrt(2)*radius*cos(theta)+xcen
polygon(x,y,...)
}

draw.double.square=function(xcen,ycen,radius,ratio,...){
draw.square(xcen,ycen,radius*ratio,...)
draw.square(xcen,ycen,radius,...)
}

draw.roundRect=function(xcen,ycen,height,width,radiusFrac,prec=7,...){
realRad=radiusFrac*.5*min(height,width)
lineWidth=width-2*realRad
lineHeight=height-2*realRad
#sides
segments(xcen-width/2,ycen-lineHeight/2,xcen-width/2,ycen+lineHeight/2,...)
segments(xcen+width/2,ycen-lineHeight/2,xcen+width/2,ycen+lineHeight/2,...)
segments(xcen-lineWidth/2,ycen+height/2,xcen+lineWidth/2,ycen+height/2,...)
segments(xcen-lineWidth/2,ycen-height/2,xcen+lineWidth/2,ycen-height/2,...)
#corners
theta=seq(0,pi/2,len=2^floor(prec)+1)
y=realRad*sin(theta)+(height/2)-realRad+ycen
x=realRad*cos(theta)+(width/2)-realRad+xcen
lines(x,y,...)
theta=seq(pi/2,pi,len=2^floor(prec)+1)
y=realRad*sin(theta)+(height/2)-realRad+ycen
x=realRad*cos(theta)-(width/2)+realRad+xcen
lines(x,y,...)
theta=seq(pi,3*pi/2,len=2^floor(prec)+1)
y=realRad*sin(theta)-(height/2)+realRad+ycen
x=realRad*cos(theta)-(width/2)+realRad+xcen
lines(x,y,...)
theta=seq(3*pi/2,2*pi,len=2^floor(prec)+1)
y=realRad*sin(theta)-(height/2)+realRad+ycen
x=realRad*cos(theta)+(width/2)-realRad+xcen
lines(x,y,...)
}
