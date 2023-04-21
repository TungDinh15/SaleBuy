$(document).ready(() => {

  var url = "http://localhost:3000";

  $("#btn_AddNewCity").click(() => {
    $.post(url + "/city/add", { Name: $("#cityName").val() }, (data) => {
      console.log(data);
      if (data.result === 1) {
        $.post(url + "/city", (data2) => {

          console.log(data2);

          if (data2.result == 1) {
            $("#city_List").html("");
            data2.list.forEach(function (city) {
              $("#city_List").append(`
                <li class="city" cityID="` + city._id + `">` + city.Name + `</li>
              `);
            });
          }

        });
      }
    })
  });

});