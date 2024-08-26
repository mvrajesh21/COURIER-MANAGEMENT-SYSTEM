package com.klef.ep.beans;

import java.io.IOException;
import java.util.List;

import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.klef.ep.models.Dispatcher;
import com.klef.ep.services.DispatcherService;

@ManagedBean(name="dispatcherbean", eager=true)
public class DispatcherBean {
    @EJB(lookup="java:global/CourierSMProject/DispatcherServiceImpl!com.klef.ep.services.DispatcherService")
    DispatcherService dispatchservice;

    private String username;
    private String contact;
    private String email;
    private String address;
    private String city;
    private String pincode;
    private String password;
    
    private List<Dispatcher> dislist;
  
    public List<Dispatcher> getDislist() {
		return dispatchservice.viewalldis();
	}
	public void setDislist(List<Dispatcher> dislist) {
		this.dislist = dislist;
	}
	
	// Getters and Setters
    public String getUsername() 
    {
    	return username; 
    }
    public void setUsername(String username) 
    {
    	this.username = username; 
    }
    public String getContact() 
    {
    	return contact; 
    }
    public void setContact(String contact) 
    { 
    	this.contact = contact; 
    }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
  

    public String add() {
        Dispatcher d = new Dispatcher();
        d.setUsername(username);
        d.setContact(contact);
        d.setEmail(email);
        d.setAddress(address);
        d.setCity(city);
        d.setPincode(pincode);
        d.setPassword(password);

        dispatchservice.adddispatcher(d);

        return "dispatcherlogin.jsf";
    }
    
    public String delete(String contact)
	{
    	dispatchservice.deletedispatcher(contact);
		
		return "dispatcher.jsf";
	}

    public String update() {
        Dispatcher dispatcher = dispatchservice.dispatcheremail(email);

        if (dispatcher != null) {
            dispatcher.setPassword(password);
            dispatchservice.updatedispatcher(dispatcher);
            
            return "updatesuccess.jsf";
        } else {
            return "updatefail.jsf";
        }
    }

    public void validateemail() throws IOException {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        HttpServletRequest request = (HttpServletRequest) externalContext.getRequest();
        HttpServletResponse response = (HttpServletResponse) externalContext.getResponse();

        Dispatcher dispatch = dispatchservice.dispatcheremail(email);

        if (dispatch != null) {
            HttpSession session = request.getSession();
            session.setAttribute("dispatcher", dispatch);
            response.sendRedirect("forgotpassword.jsf");
        } else {
            response.sendRedirect("verifyfail.jsf");
        }
    }

    public void validatedispatcherlogin() throws IOException {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        ExternalContext externalContext = facesContext.getExternalContext();
        HttpServletRequest request = (HttpServletRequest) externalContext.getRequest();
        HttpServletResponse response = (HttpServletResponse) externalContext.getResponse();

        Dispatcher dispatch = dispatchservice.dispatcherlogin(username, password);

        if (dispatch != null) {
            HttpSession session = request.getSession();
            session.setAttribute("dispatcher", dispatch);
            response.sendRedirect("dispatcherhome.jsp");
        } else {
            response.sendRedirect("dispatcherloginfail.jsf");
        }
    }
}
