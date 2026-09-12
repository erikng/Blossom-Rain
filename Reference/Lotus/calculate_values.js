function calculate_values(){
      var magnesium, calcium, sodium, potassium;
      var dropperStyleConversion;

      // Determine dropper style conversion factor
      switch (jQuery(".dropper-style input:checked").val()){
        case "round":
          dropperStyleConversion = 0.56;
          break;
        case "straight":
          dropperStyleConversion = 1;
          break;
        default:
          dropperStyleConversion = 1;
      }

      var selectedRecipe = jQuery('#recipe').val();
      var isCustom = selectedRecipe === "Custom Recipe";

      // Check if a valid recipe is selected
      if(selectedRecipe && selectedRecipe !== "Select Recipe"){
        // Proceed with calculations

        if(isCustom){
          // Retrieve custom ppm values
          var ppmmg = parseFloat(jQuery('#custom-ppmMg').val()) || 0;
          var ppmca = parseFloat(jQuery('#custom-ppmCa').val()) || 0;
          var ppmk = parseFloat(jQuery('#custom-ppmK').val()) || 0;
          var ppmna = parseFloat(jQuery('#custom-ppmNa').val()) || 0;
          var description = "<p>You have created a custom recipe.</p>"; // Optional: Customize as needed
          var logo = ""; // Optional: Set a default logo or leave blank
        } else {
          // Retrieve predefined ppm values
          var ppmmg = parseFloat(jQuery('#recipe option:selected').data('ppmmg')) || 0;
          var ppmca = parseFloat(jQuery('#recipe option:selected').data('ppmca')) || 0;
          var ppmk = parseFloat(jQuery('#recipe option:selected').data('ppmk')) || 0;
          var ppmna = parseFloat(jQuery('#recipe option:selected').data('ppmna')) || 0;
          var description = jQuery('#recipe option:selected').data('description') || "";
          var logo = jQuery('#recipe option:selected').data('logo') || "";
        }

        var unit = jQuery('.units-row input[type="radio"]:checked').val();

        // Volume conversion factors
        var conversionFactor = 1; // Default value
        if(unit == 'ml-range'){
          var ml = parseFloat(jQuery('.ml-range input[type="range"]').val()) || 0;
          conversionFactor = ml / 4500;
        }
        if(unit == 'liter-range'){
          var liter = parseFloat(jQuery('.liter-range input[type="range"]').val()) || 0;
          conversionFactor = liter / 4.5;
        }
        if(unit == 'gallon-range'){
          var gal = parseFloat(jQuery('.gallon-range input[type="range"]').val()) || 0;
          conversionFactor = gal / (4500 / 3785);
        }

        // Calculate ppm values
        magnesium = ppmmg * conversionFactor * dropperStyleConversion;
        calcium = ppmca * conversionFactor * dropperStyleConversion;
        potassium = 2 * ppmk * conversionFactor * dropperStyleConversion;
        sodium = 2 * ppmna * conversionFactor * dropperStyleConversion;

        // Update the results display
        jQuery('.step1-results-wrap .results-list > div.magnesium .list-val').text(Math.round(magnesium));
        jQuery('.step1-results-wrap .results-list > div.calcium .list-val').text(Math.round(calcium));
        jQuery('.step1-results-wrap .results-list > div.potassium .list-val').text(Math.round(potassium));
        jQuery('.step1-results-wrap .results-list > div.sodium .list-val').text(Math.round(sodium));

        // Update description and logo
        jQuery('.description-content').html(description);
        if(logo){
          jQuery('.recipe-logo').attr('src', logo).show();
        } else {
          jQuery('.recipe-logo').hide();
        }

        // Update ions
        jQuery('.ion-item.mg .ion-val').text(Math.round(ppmmg * (24.305 / 100)));
        jQuery('.ion-item.k .ion-val').text(Math.round(2 * ppmk * (39.0983 / 100)));
        jQuery('.ion-item.ca .ion-val').text(Math.round(ppmca * (40.078 / 100)));
        jQuery('.ion-item.na .ion-val').text(Math.round(2 * ppmna * (22.989 / 100)));
        // Corrected calculations for Chloride and Bicarbonate
        jQuery('.ion-item.cl .ion-val').text(Math.round(2 * ppmmg * (35.453 / 100) + 2 * ppmca * (35.453 / 100)));
        jQuery('.ion-item.hco3 .ion-val').text(Math.round(2 * ppmna * (61.016 / 100) + 2 * ppmk * (61.016 / 100)));

        // Update Chart.js scatter plot
        var x_val = ppmk + ppmna;
        var y_val = ppmmg + ppmca;
        var xyValues = [
          {x: x_val, y: y_val}
        ];

        // Define maximum values with constraints to prevent extreme scaling
        var xMax = (x_val > 0) ? (x_val > 100 ? x_val * 1.2 : 100) : 100;
        var yMax = (y_val > 0) ? (y_val > 160 ? y_val * 1.2 : 160) : 160;

        // Update chart data
        myChart.data.datasets[0].data = xyValues;

        // Update chart scales
        myChart.options.scales.x.min = 0;
        myChart.options.scales.x.max = xMax;

        myChart.options.scales.y.min = 0;
        myChart.options.scales.y.max = yMax;

        // Update the chart
        myChart.update();

        // Show the results section
        jQuery('.step1-results-wrap').slideDown();
      } else {
        // Hide the results section if no valid recipe is selected
        jQuery('.step1-results-wrap').slideUp();
        // Optionally, clear the chart when no recipe is selected
        myChart.data.datasets[0].data = [];
        myChart.update();
      }
    }