package com.htc.aws.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AWSController {

	@RequestMapping("/Welcome")
	public String Common() {
		String Message = "Spring Boot Deployment into AWS EC2 with Teraaform Cloud and Github Actions";
		return Message;
		
	}
}
