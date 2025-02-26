  library("dplyr") 
  library(OpenStreetMap)
   library(ggforce)
  library(sf)
  library(osrm)
  #library(emojifont)
  # library(ggimage)
  library(shinyjs)  
  
  ui <-fluidPage(
  
    sidebarLayout(
      
      sidebarPanel(
        tabsetPanel(
          tabPanel("main",
                   sliderInput("main_range_long", "main Longtitude range",
                               min = 32.51, max = 32.80, value =c(32.60,32.705),
                   ),
                   sliderInput("main_range_lat", "main Latitude range",
                               min = 41.0, max = 41.40, value = c(41.17,41.27),
                   ),
          ),
          tabPanel("First box",
                   sliderInput("S_zoom_range_x", "Zoom Longtitude range",
                               min = 32.67, max = 32.685, value = c( 32.67, 32.685),
                   ),
                   sliderInput("S_zoom_range_y", "Zoom Latitude range",
                               min = 41.245, max = 41.26, value = c( 41.245, 41.26),
                   ),
                   
                   sliderInput("S_pzoom_range_x", "Zoomed place Longtitude range",
                               min = 32.51, max = 32.80, value =c(32.662,32.7115),
                   ),
                   
                   sliderInput("S_pzoom_range_y", "Zoomed place Latitude position",
                               min = 41.0, max = 41.40, value = c(41.222 ),
                   ),
                   
                   
                   sliderInput("S_point_x", "Point Longtitude position",
                               min = 32.67, max = 32.68, value = c(32.675),
                   ),
                   
                   sliderInput("S_point_y", "Point Latitude position",
                               min = 41.24, max = 41.26, value = c(41.25),
                   )
          ),
          tabPanel("Second box",
                   sliderInput("K_zoom_range_x", "Zoom Longtitude range",
                               min = 32.51, max = 32.80, value = c( 32.605, 32.62),
                   ),
                   sliderInput("K_zoom_range_y", "Zoom Latitude range",
                               min = 41.18, max = 41.26, value = c(  41.192,41.208),
                   ),
                   
                   sliderInput("K_pzoom_range_x", "Zoomed place Longtitude range",
                               min = 32.51, max = 32.80, value =c(32.596,32.645),
                   ),
                   
                   sliderInput("K_pzoom_range_y", "Zoomed place Latitude position",
                               min = 41.0, max = 41.40, value = c(41.27 ),
                   ),
                   
                   
                   sliderInput("K_point_x", "Point Longtitude position",
                               min = 32.60, max = 32.7, value = c(32.6085),
                   ),
                   
                   sliderInput("K_point_y", "Point Latitude position",
                               min = 41.14, max = 41.26, value = c(41.2),
                   )
          ),
          
         
          
          tabPanel("Zoom Level",
                     selectInput("zoomlevel", "Zoom Level:",
                              c(NA,0:20),selected = 15),
                 
                     )
          
        ),useShinyjs(),  # Set up shinyjs
        
        shiny::actionButton("btn", "Make map"),
        downloadButton("downloadPlot", "Download Plot")
      ),
    mainPanel(
             plotOutput("plotum") ,
             textOutput('msg')
      
     )
      
    )
  )
  
  
  
  server  <- function(input, output, session) {
    #reactiveB <- reactive({  
      observe({
      updateSliderInput(session, "S_zoom_range_x"  , label = NULL,  
                        min = input$main_range_long[1], max =input$main_range_long[2] )
      updateSliderInput(session, "S_zoom_range_y"  , label = NULL,  
                        min = input$main_range_lat[1], max =input$main_range_lat[2] )
      updateSliderInput(session, "S_point_x"  , label = NULL,  #value= round(mean(input$S_zoom_range_x), digits = 3),
                        min = input$S_zoom_range_x[1], max =input$S_zoom_range_x[2] )
      updateSliderInput(session, "S_point_y"  , label = NULL,  #value= round(mean(input$S_zoom_range_y), digits = 3),
                        min = input$S_zoom_range_y[1], max =input$S_zoom_range_y[2] ) 
      updateSliderInput(session, "K_zoom_range_x"  , label = NULL,  
                        min = input$main_range_long[1], max =input$main_range_long[2] )
      updateSliderInput(session, "K_zoom_range_y"  , label = NULL,  
                        min = input$main_range_lat[1], max =input$main_range_lat[2] )
          updateSliderInput(session, "K_point_x"  , label = NULL,   #value= round(mean(input$K_zoom_range_x), digits = 3),
                        min = input$K_zoom_range_x[1], max =input$K_zoom_range_x[2] )
      updateSliderInput(session, "K_point_y"  , label = NULL,  #value= round(mean(input$K_zoom_range_y), digits = 3),
                        min = input$K_zoom_range_y[1], max =input$K_zoom_range_y[2] ) 
    
      
      })
    observeEvent( input$btn, {
    

    
        lat1 <-input$main_range_lat[1] ; lat2 <-input$main_range_lat[2];
        lon1 <-input$main_range_long[1] ; lon2 <- input$main_range_long[2]
        S_point_x <-input$S_point_x[1] ;S_point_y <-input$S_point_y[1] ;
        S_lat <-input$S_zoom_range_y ;S_lon <-input$S_zoom_range_x;
        K_point_x <-input$K_point_x[1] ;K_point_y <-input$K_point_y[1] ;
        K_lat <-input$K_zoom_range_y ;K_lon <-input$K_zoom_range_x;
        zoomlevel<-input$zoomlevel
        veriler<<-list()
        j<<-0
        
     #   pointLong=input$point_range_x;pointLat=input$point_range_y;  
        MyShapes= c("Cafe" = 2, "Market" =  8,"Park"=0,"Resturant"=5)
        MyCoulur= c("Cafe" = "red", "Market" =  "black","Park"="orange","Resturant"="blue")
        adlar<-c("Resturant","Cafe","Market","Park")
        data<-read.csv("tum_mesafe.csv")
        fulltheme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.text.x=element_blank(), axis.text.y=element_blank(),axis.ticks=element_blank(),axis.title.x=element_blank(), axis.title.y=element_blank())
        zoomtheme <- theme(legend.position="none", axis.line=element_blank(),axis.text.x=element_blank(), axis.text.y=element_blank(),axis.ticks=element_blank(), axis.title.x=element_blank(),axis.title.y=element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                           panel.background = element_rect(  fill="white" ), plot.margin = unit(c(0,0,-6,-6),"mm"),  panel.border = element_rect(colour = "red", fill=NA, size=0.2))
        makeData<-function(x, lon1, lon2, lat1 , lat2){
           alldata<-x %>%  filter(between(longitude , lon1, lon2))  %>% filter(between(latitude, lat1 , lat2))  %>% filter(name>0) %>%
            mutate(Type=ifelse(name==1  | name==4, "Resturant",ifelse(name==2 | name==5, "Cafe" ,ifelse (name==3,"Market","Park" )))) %>%
            mutate(renk=ifelse(name==1  | name==4, "red",ifelse(name==2 | name==5, "black" ,ifelse (name==3,"green","blue" ))))
  
         data.frame(alldata)
        }
        prepareMap<-function(y2,x1,y1,x2,z){
          options(osrm.server = "https://router.project-osrm.org/") #"http://0.0.0.0:5000/")
          # options(osrm.profile = "foot")
          j<<-j+1
          veriler[[j]]<<-c(y2,x1,y1,x2,z)
          Vname<-paste0("files/",z,"_",y2,"_" ,x1,"_" ,y1,"_" ,x2, ".RData")
         if(file.exists(Vname)){
           load(Vname)
           Gsa_map2 <<-Gsa_map2 
          return(load(Vname))
         }
          if(z=="NA"){
            sa_map <- openmap(c(y2,x1), c(y1,x2), type = "osm"  ,mergeTiles = T )
          }else{
            sa_map <- openmap(c(y2,x1), c(y1,x2), type = "osm", zoom=z ,mergeTiles = T )
          }
          
          Gsa_map2 <<- openproj(sa_map)
          save(Gsa_map2, file = Vname)
          return()
        }
       MakBuffers<-function(pointLong,pointLat){

         pointLong<<-pointLong;pointLat<<-pointLat
         points2<-data.frame(v1=c("p0"),X=c(pointLong),Y=c(pointLat))
         colnames(points2) <- c("NAME", "X", "Y")
         # Create points and buffers
         ps <- st_as_sf(points2, coords = c(2:3), remove = FALSE, crs="EPSG:4326")
         ps$X <- as.numeric(ps$X); ps$Y <- as.numeric(ps$Y)
         blist <- c(400, 800, 1200)
         bufs <- lapply(seq_along(blist), function(x) st_buffer(ps[1,], blist[x],  
                                                                endCapStyle = "ROUND",
                                                                joinStyle = "ROUND"))
         bufs <- do.call(rbind, bufs)
       #  print(c(pointLong,pointLat))
         iso <- osrmIsometric(loc = c(pointLong,pointLat), breaks=blist  ,osrm.profile ="foot", returnclass="sf",
                              osrm.server = "https://router.project-osrm.org/")# "http://0.0.0.0:5000/")
         iso<-iso %>% mutate(X=c(pointLong),Y=c(pointLat))
         return(list(buffer= bufs ,isom=iso))
          assign(Vname,list(buffer= bufs ,isom=iso))
                 get(Vname)     
       }   
        genelMap<-function(lon1, lon2, lat1 , lat2,mydf,mydfk){ #

          prepareMap(lat2, lon1 ,  lat1, lon2,zoomlevel)
          gmakeData<<-makeData(data, lon1, lon2, lat1 , lat2) 
          Ggenel<-OpenStreetMap::autoplot.OpenStreetMap(Gsa_map2)+
            geom_point(data =gmakeData   ,aes(x = longitude,   y = latitude,colour= Type,shape=Type),size=1)+ 
           geom_segment(data = mydf, aes(x = lon_1, y = lat_1, xend = lon_2, yend = lat_2), color = "red", size = 0.2, alpha = 1) +
            geom_segment(data = mydfk, aes(x = lon_1, y = lat_1, xend = lon_2, yend = lat_2), color = "blue", size = 0.2, alpha = 1) +
            scale_color_manual(values =MyCoulur) +    
        
     #    geom_sf(data = KarabukBuffer$isom , mapping = aes(x=X,y=Y), fill="transparent",colour="purple",size=0.1, expand_limits=F)+
    #  geom_sf(st_crop(KarabukBuffer[["buffer"]], box), mapping = aes(x=X,y=Y), fill="transparent", size=0.3, inherit.aes = T)+ 
                coord_sf(xlim = c(lon1, lon2), ylim = c(lat1, lat2))+# 
          
            xlab("") + ylab("")+  fulltheme
          Ggenel
        }  
      
        
        AltMap<-function(lon1, lon2, lat1 , lat2,point_x,point_y,renk){
          prepareMap(lat2, lon1 ,  lat1, lon2,zoomlevel)
          buffer<-MakBuffers(point_x,point_y)
          Kgenel<-OpenStreetMap::autoplot.OpenStreetMap(Gsa_map2)+
            geom_point(x=point_x,y=point_y,col="brown4", size = 4 )+
            geom_point(data =makeData(data, lon1, lon2, lat1 , lat2)   ,aes(x = longitude,   y = latitude,colour= Type,shape=Type),size=1)+ 
             
           geom_sf(data =  buffer$isom, mapping = aes(x=X,y=Y), fill="transparent",colour="purple",size=0.1)+
           geom_sf(buffer$buffer, mapping = aes(x=X,y=Y), fill="transparent", size=0.3)+ 
            scale_color_manual(values =MyCoulur) +  
            xlab("") + ylab("")+  
            coord_sf(xlim = c(lon1, lon2), ylim = c(lat1, lat2), expand=F)+
            zoomtheme+theme(  panel.border = element_rect(colour =renk, fill=NA, size=0.2))
          Kgenel
        }     

        sinirlarz<-function(lon_bounds,lat_bounds){
          data.frame(id = 1:4, 
                          lat_1 = c(lat_bounds[1], lat_bounds[2], lat_bounds[2],lat_bounds[1]), 
                          lon_1 = c(lon_bounds[1], lon_bounds[1], lon_bounds[1],lon_bounds[2]), 
                          lat_2 = c(lat_bounds[1], lat_bounds[2], lat_bounds[1],lat_bounds[2]), 
                          lon_2 = c(lon_bounds[2], lon_bounds[2], lon_bounds[1],lon_bounds[2]))
        }
        
        son <- reactive({
          
  
       zoom.Sxmin <-input$S_pzoom_range_x[1]; zoom.Sxmax<-input$S_pzoom_range_x[2];
       zoom.Symax <-input$S_pzoom_range_y
       zoomed.ratio<-((S_lon[2]- S_lon[1])/(S_lat[2]-S_lat[1]))
       zoom.Symin <-zoom.Symax- (zoom.Sxmax - zoom.Sxmin )/zoomed.ratio #-40;
       mydf <- sinirlarz(S_lon,S_lat)
       
       zoom.Kxmin <-input$K_pzoom_range_x[1]; zoom.Kxmax<-input$K_pzoom_range_x[2];
       zoom.Kymax <-input$K_pzoom_range_y
       zoomed.ratio<-((K_lon[2]- K_lon[1])/(K_lat[2]-K_lat[1]))
       zoom.Kymin <-zoom.Kymax- (zoom.Kxmax - zoom.Kxmin )/zoomed.ratio #-40;
       mydfk <- sinirlarz(K_lon,K_lat)  
       
       # KarabukBuffer<<-MakBuffers(input$K_point_x,input$K_point_y)
       # SafranboluBuffer<<-MakBuffers(input$S_point_x,input$S_point_y)
        print(c(input$K_point_x,input$K_point_y))
     buyuk<<-  genelMap(lon1, lon2, lat1 , lat2,mydf,mydfk)
    Safran<<- AltMap(S_lon[1], S_lon[2], S_lat[1] , S_lat[2],input$S_point_x,input$S_point_y,"red")#, MakBuffers(input$S_point_x,input$S_point_y))# SafranboluMap(S_lon[1], S_lon[2], S_lat[1] , S_lat[2])
    Karabuk<<-AltMap(K_lon[1], K_lon[2], K_lat[1] , K_lat[2],input$K_point_x,input$K_point_y,"blue")#,MakBuffers(input$K_point_x,input$K_point_y)) #KarabukMap(K_lon[1], K_lon[2], K_lat[1] , K_lat[2],K_point_x,K_point_y)
    #  
 #    buyuk
     
     g <- ggplotGrob(Safran )
     g2 <- ggplotGrob(Karabuk )
     buyuk+ annotation_custom(grob = g, xmin = zoom.Sxmin, xmax = zoom.Sxmax   , ymin =zoom.Symin  , ymax = zoom.Symax)+
       annotation_custom(grob = g2, xmin = zoom.Kxmin, xmax = zoom.Kxmax   , ymin =zoom.Kymin  , ymax = zoom.Kymax)
          
        })
     output$plotum <- renderPlot({
     
       
   son()
      #   filenameim<- paste0("~/Downloads/",zoomlevel,"_", Sys.time(),".jpg")
       #   ggsave(filename = filenameim, son  ,            width = 10,  height =10, dpi =300, units = "in", device='jpeg', bg = "white")
   
     } )
     
     output$downloadPlot <- downloadHandler(
       filename = function() {
         paste0("plot_", input$zoomlevel, "_", Sys.time(), ".jpg")
       },
       content = function(file) {
         ggsave(file, plot = son(), width = 10, height = 10, dpi = 300, 
                units = "in", device = "jpeg", bg = "white")
       }
     )
     
     
     
    } )
    
  }
  shinyApp(ui = ui, server = server)