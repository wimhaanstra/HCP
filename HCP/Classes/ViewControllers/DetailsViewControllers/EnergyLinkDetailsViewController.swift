//
//  EnergyLinkDetailsViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 21/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class EnergyLinkDetailsViewController: SensorDetailsViewController, TKChartDataSource, TKChartDelegate {
	
	var graphItems = [GraphValue]();
	var chart = TKChart();
	var activityIndicator = UIActivityIndicatorView();
	
	override func viewDidLoad() {
		super.viewDidLoad()

//		var predicate = NSPredicate(format: "timeStamp > %@",
		
		var r = GraphValue.requestAllSortedBy("timeStamp", ascending: false);
		r.fetchLimit = 60;
		self.graphItems = GraphValue.executeFetchRequest(r) as [GraphValue];
		
		self.view.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);
		
		chart.backgroundColor = UIColor.clearColor();
		
		var xAxis = TKChartDateTimeAxis();
		xAxis.majorTickInterval = 1;
		xAxis.style.minorTickStyle.ticksHidden = false;
		xAxis.position = TKChartAxisPositionBottom;
		xAxis.style.labelStyle.textColor = UIColor(white: 1.0, alpha: 0.6);
		chart.addAxis(xAxis);
		
		var yAxis = TKChartNumericAxis();
		yAxis.style.minorTickStyle.ticksHidden = false;
		yAxis.position = TKChartAxisPositionLeft;
		yAxis.style.labelStyle.textColor = UIColor(white: 1.0, alpha: 0.6);
		chart.addAxis(yAxis);

		var chartStyle = chart.gridStyle();
		chartStyle.horizontalFill = nil;
		chartStyle.horizontalAlternateFill = TKSolidFill(color: UIColor(white: 1.0, alpha: 0.2));
		chartStyle.horizontalLineStroke = nil;
		chartStyle.horizontalLineAlternateStroke = nil;
		
		chart.dataSource = self;
		chart.delegate = self;
		
		self.view.addSubview(chart);
		self.chart.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top);
		self.chart.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.closeButton);
		
		self.view.addSubview(self.textLabel);
		
		self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White;
		self.view.addSubview(self.activityIndicator);
		
		self.activityIndicator.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view, withOffset: -5);
		self.activityIndicator.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self.view, withOffset: -5);
		self.activityIndicator.alpha = 0.4;
		self.activityIndicator.startAnimating();
	}
	
	func seriesForChart(chart: TKChart!, atIndex index: UInt) -> TKChartSeries! {
		var series = chart.dequeueReusableSeriesWithIdentifier("electricity") as TKChartSplineAreaSeries?;
		
		if (series == nil) {
			series = TKChartSplineAreaSeries(items: [], reuseIdentifier: "electricity");
			series!.title = "Electricity";

			series!.style.palette = TKChartPalette();
			
			var palleteItem = TKChartPaletteItem(stroke: TKStroke(color: UIColor.whiteColor()));
			palleteItem.stroke.width = 3;
			palleteItem.fill = TKSolidFill(color: UIColor(white: 1.0, alpha: 0.2));
			series!.style.palette!.addPaletteItem(palleteItem)
		}
		
		return series;
	}
	
	func numberOfSeriesForChart(chart: TKChart!) -> UInt {
		return 1;
	}
	
	func chart(chart: TKChart!, numberOfDataPointsForSeriesAtIndex seriesIndex: UInt) -> UInt {
		NSLog("\(graphItems.count)");
		return UInt(graphItems.count);
	}
	
	func chart(chart: TKChart!, dataPointAtIndex dataIndex: UInt, forSeriesAtIndex seriesIndex: UInt) -> TKChartData! {
		
		var item = graphItems[Int(dataIndex)];
		
		var point = TKChartDataPoint();
		point.dataXValue = item.timeStamp!;
		point.dataYValue = item.value;
		
		return point;
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		self.view.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);

		self.activityIndicator.startAnimating();

		(self.sensor as EnergyLink).getGraphValues(kGraphResolution.Day, completion: { (results) -> Void in
			XCGLogger.defaultInstance().debug("\(results)");
			
			var r = GraphValue.requestAllSortedBy("timeStamp", ascending: false);
			r.fetchLimit = 60;
			self.graphItems = GraphValue.executeFetchRequest(r) as [GraphValue];

			self.chart.reloadData();
			
			self.activityIndicator.stopAnimating();
		});
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
