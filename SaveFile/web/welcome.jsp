<%-- 
    Document   : welcome
    Created on : Apr 17, 2016, 6:13:43 PM
    Author     : Sarthak
--%>


<%@page import="java.net.MalformedURLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <!-- Compiled and minified CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.6/css/materialize.min.css">
        <!--Import Google Icon Font-->
        <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!-- Compiled and minified JavaScript -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.6/js/materialize.min.js"></script>
        <style>
            .bg {
                margin: 50px auto;
            }
        </style>
    </head>
    <body class="flow-text black-text grey lighten-3">
        <div class="navbar-fixed">
            <nav class="pink darken-4">
              <div class="nav-wrapper">
                <a href="#" class="brand-logo">TravelEasy</a>
                <ul class="right hide-on-med-and-down">
                  <li><a href="index.html">Get Fare</a></li>                  
                </ul>
              </div>
            </nav>
        </div> 
        
        
       
        <%! 
        
        HashMap<String, String> fare = new HashMap<String, String>();
        
        
        public JSONObject myGeo(String src) throws MalformedURLException, JSONException, IOException {
            String apikey = "AIzaSyAtszAccIa4-7V_GLS1AxJd4IUOa28CRaw";
            URL url = new URL("https://maps.googleapis.com/maps/api/geocode/json?address="+src+"&key="+apikey);
            HttpURLConnection connection= (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            String s= "";
            Scanner sc = new Scanner(connection.getInputStream());
            while(sc.hasNext()){
                s+=sc.nextLine();
            }
            System.out.println(s);
            JSONObject object = new JSONObject(s);
            JSONObject res = object.getJSONArray("results").getJSONObject(0);
            System.out.println(res.getString("formatted_address"));
            JSONObject loc = res.getJSONObject("geometry").getJSONObject("location");
            System.out.println("lat: " + loc.getDouble("lat") +
                                ", lng: " + loc.getDouble("lng"));

            return loc;

        }
        
        
        public String mydistance(String src, String dest) throws JSONException, IOException {
            String apikey = "AIzaSyAtszAccIa4-7V_GLS1AxJd4IUOa28CRaw";
            //String src = "Hari+Nagar+New+Delhi";
            //String dest = "Tilak+Nagar+New+Delhi";
            URL url= new URL("https://maps.googleapis.com/maps/api/distancematrix/json?origins="+src+"&destinations="+dest+"&key="+apikey);
            HttpURLConnection connection= (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            String s= "";
            Scanner sc = new Scanner(connection.getInputStream());
            while(sc.hasNext()){
                s+=sc.nextLine();
            }
            System.out.println(s);
            JSONObject object = new JSONObject(s);
            JSONObject temp = object.getJSONArray("rows").getJSONObject(0).getJSONArray("elements").getJSONObject(0);
            JSONObject b = temp.getJSONObject("distance");
            String distance = b.getString("text");
            return distance;
        }
                
        public void myUber(String lts, String lgs, String ltd, String lgd) throws MalformedURLException, IOException, JSONException {
            String uberUrl = "https://www.uber.com/api/fare-estimate?"+
                          "pickupRef=&pickupLat="+lts+"&pickupLng="+lgs+"&destinationRef=" +
                          "&destinationLat="+ltd+"&destinationLng="+lgd;
            URL url = new URL(uberUrl);
            HttpURLConnection connection= (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            String s= "";
            Scanner sc = new Scanner(connection.getInputStream());
            while(sc.hasNext()){
                s+=sc.nextLine();
            }
            System.out.println(s);
            JSONObject object = new JSONObject(s);
            String temp = object.getJSONArray("prices").getJSONObject(0).getString("fareString");        
            String uberpool = temp.substring(5);
            temp = object.getJSONArray("prices").getJSONObject(2).getString("fareString");
            String ubergo = temp.substring(5);
            temp = object.getJSONArray("prices").getJSONObject(4).getString("fareString");
            String uberX = temp.substring(5);
            temp = object.getJSONArray("prices").getJSONObject(6).getString("fareString");
            String uberXl = temp.substring(5);

            fare.put("response", s);
            fare.put("pool", uberpool);
            fare.put("go", ubergo);
            fare.put("x", uberX);
            fare.put("xl", uberXl);

        }
    
        public void myOla(Double distance) {
            if(distance <= 4.00) {
                fare.put("mini", "100");
                fare.put("prime", "100");
                fare.put("bike", "20");
                fare.put("micro", "40");
            }
            else {
                Double temp = 100 + (distance - 4.00)*8;
                fare.put("mini", Double.toString(temp));
                temp = 100 + (distance - 4.00)*10;
                fare.put("prime", Double.toString(temp));
                temp = 20 + (distance - 4.00)*4;
                fare.put("bike", Double.toString(temp));
                temp = 40 + (distance - 4.00)*6;
                fare.put("micro", Double.toString(temp));
            }
        }

        public void myJugnoo(Double distance) {
            Double temp = distance * 9.12 + 15;
            temp = Math.round(temp * 100.0)/100.0;
            fare.put("jugnoo", Double.toString(temp));        
        }

        public void myDTC(Double distance) {
            if(distance <= 5.00) {
                fare.put("greenBus", "5");
                fare.put("redBus", "10");
            }
            else if(distance <= 10.00 && distance > 5.00) {
                fare.put("greenBus", "10");
                fare.put("redBus", "15");
            }
            else {
                fare.put("greenBus", "15");
                fare.put("redBus", "25");
            }
        }

        public void myMain(HttpServletRequest request) throws JSONException, IOException{
                String src = request.getParameter("src");
                String dest = request.getParameter("dest");
                String distance = mydistance(src, dest);
                JSONObject geoS = myGeo(src);
                JSONObject geoD = myGeo(dest);

                Double ltS = geoS.getDouble("lat");
                Double lgS = geoS.getDouble("lng");

                Double ltD = geoD.getDouble("lat");
                Double lgD = geoD.getDouble("lng");

                String slt = Double.toString(ltS);
                String slg = Double.toString(lgS);
                String dlt = Double.toString(ltD);
                String dlg = Double.toString(lgD);


                myUber(slt, slg, dlt, dlg);

                Double dist = Double.parseDouble(distance.substring(0, 2));
                myOla(dist);
                myJugnoo(dist);
                myDTC(dist);
        }
        %>
        <% myMain(request);  %>
        <section class="container">
            
            <div class="card-panel indigo bg">
                <h1>Uber</h1>
                <p>Uber pool: <%= fare.get("pool")    %></p>
                <p>Uber go: <%= fare.get("go")    %></p>
                <p>Uber X: <%= fare.get("x")    %></p>
                <p>Uber Xl: <%= fare.get("xl")    %></p>
            </div>
            <div class="card-panel indigo bg">
                <h1>Ola</h1>
                <p>Ola mini: <%= fare.get("mini")    %></p>
                <p>Ola prime: <%= fare.get("prime")    %></p>
                <p>Ola bike: <%= fare.get("bike")    %></p>
                <p>Ola micro: <%= fare.get("micro")    %></p>
            </div>        
            <div class="card-panel indigo bg">
                <h1>DTC</h1>
                <p>DTC Redbus: <%= fare.get("redBus")    %></p>
                <p>DTC GreenBus: <%= fare.get("greenBus")    %></p>
            </div>
            <div class="card-panel indigo bg">
                <h1>Jugnoo: <%= fare.get("jugnoo")    %></h1>            
            </div>
        
        </section>
        
        <!-- Compiled and minified JavaScript -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.6/js/materialize.min.js"></script>        
    </body>
</html>
