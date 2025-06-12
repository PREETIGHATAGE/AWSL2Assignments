package com.gfg.microservices.currencyexchangesampleservice;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class ExchangeValue {

	@Id
	private Long id;

	@Column(name = "currency_from")
	private String from;

	@Column(name = "currency_to")
	private String to;

	private Double conversionMultiple;

	public ExchangeValue() {}

	public ExchangeValue(Long id, String from, String to, Double conversionMultiple) {
		this.id = id;
		this.from = from;
		this.to = to;
		this.conversionMultiple = conversionMultiple;
	}

	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }
	public String getFrom() { return from; }
	public void setFrom(String from) { this.from = from; }
	public String getTo() { return to; }
	public void setTo(String to) { this.to = to; }
	public Double getConversionMultiple() { return conversionMultiple; }
	public void setConversionMultiple(Double conversionMultiple) { this.conversionMultiple = conversionMultiple; }
}
