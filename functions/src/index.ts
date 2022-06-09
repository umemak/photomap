import * as functions from "firebase-functions";

export const mapview = functions.https.onRequest((request, response) => {
    const q = request.query
    const width = typeof q.width != 'undefined' ? q.width : 600
    const height = typeof q.height != 'undefined' ? q.height : 400
    let prefs = ""
    prefs += "['北海道', " + (q.p01 != undefined ? q.p01 : 0) + "],"
    prefs += "['青森', " + (q.p02 != undefined ? q.p02 : 0) + "],"
    prefs += "['岩手', " + (q.p03 != undefined ? q.p03 : 0) + "],"
    prefs += "['宮城', " + (q.p04 != undefined ? q.p04 : 0) + "],"
    prefs += "['秋田', " + (q.p05 != undefined ? q.p05 : 0) + "],"
    prefs += "['山形', " + (q.p06 != undefined ? q.p06 : 0) + "],"
    prefs += "['福島', " + (q.p07 != undefined ? q.p07 : 0) + "],"
    prefs += "['茨城', " + (q.p08 != undefined ? q.p08 : 0) + "],"
    prefs += "['栃木', " + (q.p09 != undefined ? q.p09 : 0) + "],"
    prefs += "['群馬', " + (q.p10 != undefined ? q.p10 : 0) + "],"
    prefs += "['埼玉', " + (q.p11 != undefined ? q.p11 : 0) + "],"
    prefs += "['千葉', " + (q.p12 != undefined ? q.p12 : 0) + "],"
    prefs += "['東京', " + (q.p13 != undefined ? q.p13 : 0) + "],"
    prefs += "['神奈川', " + (q.p14 != undefined ? q.p14 : 0) + "],"
    prefs += "['新潟', " + (q.p15 != undefined ? q.p15 : 0) + "],"
    prefs += "['富山', " + (q.p16 != undefined ? q.p16 : 0) + "],"
    prefs += "['石川', " + (q.p17 != undefined ? q.p17 : 0) + "],"
    prefs += "['福井', " + (q.p18 != undefined ? q.p18 : 0) + "],"
    prefs += "['山梨', " + (q.p19 != undefined ? q.p19 : 0) + "],"
    prefs += "['長野', " + (q.p20 != undefined ? q.p20 : 0) + "],"
    prefs += "['岐阜', " + (q.p21 != undefined ? q.p21 : 0) + "],"
    prefs += "['静岡', " + (q.p22 != undefined ? q.p22 : 0) + "],"
    prefs += "['愛知', " + (q.p23 != undefined ? q.p23 : 0) + "],"
    prefs += "['三重', " + (q.p24 != undefined ? q.p24 : 0) + "],"
    prefs += "['滋賀', " + (q.p25 != undefined ? q.p25 : 0) + "],"
    prefs += "['京都', " + (q.p26 != undefined ? q.p26 : 0) + "],"
    prefs += "['大阪', " + (q.p27 != undefined ? q.p27 : 0) + "],"
    prefs += "['兵庫', " + (q.p28 != undefined ? q.p28 : 0) + "],"
    prefs += "['奈良', " + (q.p29 != undefined ? q.p29 : 0) + "],"
    prefs += "['和歌山', " + (q.p30 != undefined ? q.p30 : 0) + "],"
    prefs += "['鳥取', " + (q.p31 != undefined ? q.p31 : 0) + "],"
    prefs += "['島根', " + (q.p32 != undefined ? q.p32 : 0) + "],"
    prefs += "['岡山', " + (q.p33 != undefined ? q.p33 : 0) + "],"
    prefs += "['広島', " + (q.p34 != undefined ? q.p34 : 0) + "],"
    prefs += "['山口', " + (q.p35 != undefined ? q.p35 : 0) + "],"
    prefs += "['徳島', " + (q.p36 != undefined ? q.p36 : 0) + "],"
    prefs += "['香川', " + (q.p37 != undefined ? q.p37 : 0) + "],"
    prefs += "['愛媛', " + (q.p38 != undefined ? q.p38 : 0) + "],"
    prefs += "['高知', " + (q.p39 != undefined ? q.p39 : 0) + "],"
    prefs += "['福岡', " + (q.p40 != undefined ? q.p40 : 0) + "],"
    prefs += "['佐賀', " + (q.p41 != undefined ? q.p41 : 0) + "],"
    prefs += "['長崎', " + (q.p42 != undefined ? q.p42 : 0) + "],"
    prefs += "['熊本', " + (q.p43 != undefined ? q.p43 : 0) + "],"
    prefs += "['大分', " + (q.p44 != undefined ? q.p44 : 0) + "],"
    prefs += "['宮崎', " + (q.p45 != undefined ? q.p45 : 0) + "],"
    prefs += "['鹿児島', " + (q.p46 != undefined ? q.p46 : 0) + "],"
    prefs += "['沖縄', " + (q.p47 != undefined ? q.p47 : 0) + "],"
    const HTML = `
  <html>
    <head>
      <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
      <script type="text/javascript">
        google.charts.load('current', {
          'packages':['geochart'],
        });
        google.charts.setOnLoadCallback(drawRegionsMap);
        function drawRegionsMap() {
          var data = google.visualization.arrayToDataTable([
            ['都道府県', '投稿数'],
            ${prefs}
          ]);
          var options = {
            region: 'JP',
            resolution: 'provinces',
          };
          var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));
          chart.draw(data, options);
        }
      </script>
    </head>
    <body>
      <div id="regions_div" style="width: ${width}px; height: ${height}px;"></div>
    </body>
  </html>
`;
    response.send(HTML);
});
