// http://stackoverflow.com/questions/2595835/how-to-hide-table-columns-in-jquery
function hideExtraColumns() {
	$.each(advCols, function(index, value){
			$('#bfTable td:nth-child('+(value+1)+')').hide();
			$('#bfTable th:nth-child('+(value+1)+')').hide();
		});
}

function showExtraColumns() {
	$.each(advCols, function(index, value){
			$('#bfTable td:nth-child('+(value+1)+')').show();
			$('#bfTable th:nth-child('+(value+1)+')').show();
		});
}

function update(plot){
		plot = (typeof plot === "undefined") ? true : plot;
		if(plot) makePlot();
		listBayesFactors();
}

function changeLogBase(){
		textBase = $('#logBase option:selected').text();
		$('#logTHspan').html( textBase );
}

function setup(){

	changeLogBase();
	$("#logBase").change( function() { changeLogBase(); update(); } );
	
	$('#analyzeSelectedButton').click( function(){
		var whichModel = chosenModel();
		analyzeModel( whichModel ); 
	});
	$('#analyzeAllButton').click( allNways );
	$('#analyzeTopButton').click( topNways );
	$('#clearButton').click( clearAnalyses );
	
	$('#bfTableContainer').jScrollPane();
	$('#effectsTableContainer').jScrollPane();
	$('#extraColsToggle').change( checkExtraCols );
	
	$('#bfImageContainer').click( makePlot );
	
	$("#showdiv").click( toggleOptions );
	
	$(".effectsSelect").click( effectsSelect );
	
	roundTo = parseInt($("#roundTo").val());
	$("#roundTo").change( function() { 
		roundTo = parseInt($(this).val());
		listBayesFactors();
	});

}

function toggleOptions(){
	if ( $("#optionsContainer").is(':visible') ){
		$("#optionsContainer").slideUp(300);
		$("#optionsContainerIcon").html("[+]");
	}else{
		$("#optionsContainer").slideDown(300);
		$("#optionsContainerIcon").html("[-]");
	}

}

function effectsSelect(){
	if( this.id == "effectsSelectNone" ){
		$('#effectsTable input[id^="effect"]').prop('checked', false);
	}
	if( this.id == "effectsSelectAll" ){
		$('#effectsTable input[id^="effect"]').prop('checked', true);
	}	
}

function clearAnalyses(){
	bayesFactors = [];
	update();
}

function checkExtraCols(){
	var checked = $('#extraColsToggle').is(':checked');
	if(checked){
		showExtraColumns();
	}else{
		hideExtraColumns();
	}
}

function listBayesFactors( sortby ){
	var i;
	var n = bayesFactors.length;
	var checked;
	var base = $('#logBase').val();

	$('#bfTableBody').html('');
	if(n<1) {return;}
	var baseBF = baseBayesFactor();
	
	if(typeof sortby !== "undefined"){
		bayesFactors.sort(dynSort(sortby));
	}
	
	for(i = 0; i < n; i++){
		if(bayesFactors[i].isBase){
			checked = "checked='checked'";
		}else{
			checked = "";
		}
		checkBox = "<input name='baseM' type='radio' " + 
						checked + 
						" value='" + i + "' " + 
						"/>";
		
		$('#bfTableBody').append('<tr id="bfRow-' + i +  '">' +
										  '<td>' + bayesFactors[i].model + '</td>' +
										  '<td>' + checkBox + '</td>' +
										  '<td><div class="progressBar"></div></td>' +
										  '<td id="niceName-' + i +  '">' + bayesFactors[i].niceName + '</td>' +
										  '<td>' + bayesFactors[i].name + '</td>' +
										  '<td class="roundMe">' + Math.exp( bayesFactors[i].bf - baseBF ) + '</td>' +
										  '<td class="roundMe">' + (bayesFactors[i].bf  / Math.log(base) - 
										  		    baseBF  / Math.log(base)) + '</td>' +
										  '<td>' + bayesFactors[i].iterations + '</td>' +
										  '<td>' + bayesFactors[i].rscaleFixed + '</td>' +
										  '<td>' + bayesFactors[i].rscaleRandom + '</td>' +
										  '<td>' + bayesFactors[i].time + '</td>' +
										  '<td>' + bayesFactors[i].duration + '</td>' +
										  '<td id="delete-' + i + '">&#10006;</td>' +
										  '</tr>'
										  );

		if( i%2 ) {
			$("#bfTableBody > tr").last().addClass("odd");
		}
				
	}
	$('td[id^="delete-"]').click( deleteRow );
	$('td[id^="delete-"]').addClass( "deleteButton" );		
	$('td[id^="niceName-"]').attr('contentEditable',true);
	$('td[id^="niceName-"]').blur( changeNiceName );
	$("input[name=baseM]").change( changeBase );
	$(".roundMe").each( roundCell );
	$('#bfTableContainer').data('jsp').reinitialise();
	checkExtraCols();
}

function changeProgress(token,percent)
{
	var row = tokenRow(token);
	if(percent==100){
		$("#bfRow-" + row).find('.progressBar').html(percent + "%");
	}else{
		$("#bfRow-" + row).find('.progressBar').html(percent + "%");
	}
}

function roundCell(){
	var value = parseFloat($(this).text());
	var pow10 = Math.pow(10,roundTo);
	$(this).html(Math.round(value*pow10)/pow10);
}

function changeNiceName() {
	var i = this.id.split("-")[1];
	bayesFactors[i].niceName = $(this).text();
	$(this).html($(this).text());
	makePlot();
}

function deleteRow() {
	var i = this.id.split("-")[1];
	var	baseBF = baseBayesFactor("index");
	bayesFactors.splice(i,1);
	if(bayesFactors.length>0 && baseBF==i){
			bayesFactors[0].isBase = true;
	}
	update();
}

function changeBase(){
	var i;
	for(i=0;i<bayesFactors.length;i++){
		if(this.value == i) {
			bayesFactors[i].isBase = true;
		}else{
			bayesFactors[i].isBase = false;
		}
	}
	update();
}

function allNways(){
	$("#bfImageContainer").html("Click to refresh.");
	$.getJSON("/custom/aov/data?what=nFac", 
		function(data) { 
			var nFac = parseInt(data);
			var i;
			if(nFac > 4) { return; }
	
			var nModels = Math.pow(2, Math.pow(2, nFac) - 1);
	
			for(i=0;i<nModels;i++){
				analyzeModel( i, false );
			}
		});	
}

function topNways(){
	$("#bfImageContainer").html("Click to refresh.");
	$.getJSON("/custom/aov/data?what=nFac", 
		function(data) { 
			var nFac = parseInt(data);
			var i, binaryRep;
	
			var nChar = Math.pow(2, nFac) - 1;
			var topModel = Math.pow(2, nChar) - 1;
	
			analyzeModel( topModel, false );
			
			for(i=0;i<nChar;i++){
				binaryRep = Array(nChar + 1).join("1").split("");
				binaryRep[i] = "0";
				binaryRep = binaryRep.join("");
				analyzeModel( parseInt(binaryRep,2), false );
			}
			
		});	
}


function listEffects(){
	$('#effectsTableBody').html('');
	 
	$.getJSON("/custom/aov/data?what=fixed",
  		function(data) {
 			var nFac = parseInt(data.nFac);
 			var effectNames = data.effects;
 			var checkBox;
			var way;
			var i;
			var wayText;
			
 			for(i=0;i<nFac;i++){
				if(i==0){
					wayText = "Main effects";
				}else{
					wayText = (i+1) + " way";
				}
				$('#effectsTableBody').append(
 					"<tr id='" + (i+1) + "way' class='effectsTableCategory'>" +
 					'<td><span class="effectsTableCatToggle">[-]</span> ' + wayText + '</td>' + 
 					'<td></td>' +
 					'<td></td>' +
 					'</tr>'
 				);	 			
			}
 					
 			$(".effectsTableCategory").click( function(){
				if($(this).find(".effectsTableCatToggle").html() == "[-]"){
					$(this).find(".effectsTableCatToggle").html("[+]")
				}else{
					$(this).find(".effectsTableCatToggle").html("[-]")
				}
				$(".effectsRow" + this.id).toggle("fast");
			});
			
 			$.each(effectNames, function(index,value){
				checkBox = "<input id='effect:" + index + "' type='checkbox' " + "/>";
 				way = value.split(":").length;
 				$('#' + way + "way").after(
 					"<tr class='effectsRow" + way + "way'>" +
 					'<td>&nbsp;</td>' + 
 					'<td>' + value + '</td>' +
 					'<td>' + checkBox + '</td>' +
 					'</tr>'
 				);	 			
 			});
 		});
	$('#effectsTableContainer').data('jsp').reinitialise();
}

function chosenModel(){
	var whichModel = 0;
	var effNum;
	$('input:checked[id^="effect:"]').each( function() {
		effNum = parseInt(this.id.split(':')[1]);
		whichModel += Math.pow(2, effNum);
	});
	return(whichModel);
}

function analyzeModel(whichModel, plot) {
	plot = (typeof plot === "undefined") ? "true" : plot;

	var iterations = $("#nIterations").val();
	var rscaleFixed = $("#rscaleFixed").val();
	var rscaleRandom = $("#rscaleRandom").val();
	
	$.getJSON("/custom/aov/data?", 
		{
			what: "analysis",
			model: whichModel,
			iterations: iterations,
			rscaleFixed: rscaleFixed,
			rscaleRandom: rscaleRandom
		},
		function(data) { getToken(data, plot); });
}

function getToken(data, plot) {
	var token = data.token;
	var percent = parseInt(data.percent);
	
	if(data.status=="done"){
		setResults(data, plot);
		changeProgress(token,percent);
	}else{
		if(token==-1){
			alert("BayesFactor error: Invalid token response from Rook.")
			return;
		}

		setResults(data, false);
		changeProgress(token,percent);
	
		setTimeout( function(){ 
			$.getJSON("/custom/aov/data?", 
				{
					what: "analysis",
					token: token
				}, function(data){ getToken(data,plot); }
			);
		}, progressPollTime);
	}	
}

function setResults(data, plot) {
	var row = tokenRow(data.token);
	if(row == null){
		bayesFactors.push(data.returnList);
		if(bayesFactors.length == 1){
			bayesFactors[0].isBase = true;
		}
		update(false);
	}else if(data.status=="done"){
		var base = bayesFactors[row].isBase;
		bayesFactors[row] = data.returnList;
		bayesFactors[row].isBase = base;
		if(bayesFactors.length == 1){
			bayesFactors[0].isBase = true;
		}
		update(plot);
	}
}


function baseBayesFactor(which){
	var whichBase=-1; 
	var i;
	for(i=0;i<bayesFactors.length;i++){
		if(bayesFactors[i].isBase){
			whichBase = i;
			break;
		}
	}
	if(which=="index"){
		return(whichBase);
	}else if (whichBase == -1){
		return(0);
	}else{
		return(bayesFactors[whichBase].bf);
	}
}

function tokenRow(token){
	var which; 
	var i;
	for(i=0;i<bayesFactors.length;i++){
		if(bayesFactors[i].token == token){
			return(i);
		}
	}
	return(null);
}


function extractBayesFactors(){
	allBFs = [];
	var i;
	var baseBF = baseBayesFactor();
	for(i=0;i<bayesFactors.length;i++){
			allBFs.push( 
				[ Math.exp( (bayesFactors[i].bf - baseBF) ), i ]
			);
	}
	return(allBFs);
}

function extractNames(){
	allNames = [];
	var i;
	var baseBF = baseBayesFactor();
	for(i=0;i<bayesFactors.length;i++){
			allNames.push( bayesFactors[i].name );
	}
	return(allNames);
}

function makePlot()
{
	var base = $('#logBase option:selected').text();
	if(bayesFactors.length>1){
		var baseBF = baseBayesFactor();
		var BFobj = JSON.stringify(bayesFactors);
		var qstr = $.param({logBase: base, BFobj: BFobj })
		$("#bfImageContainer").html("<img src='/custom/aov/bf.png?" + qstr + "'/>");
	}else{
		$("#bfImageContainer").html("Analyze models for plot.");
	}
}

function dynSort(property) {
    return function (a,b) {
        return (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
    }
}

