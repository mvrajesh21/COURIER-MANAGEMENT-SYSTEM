package com.klef.ep.services;

import java.util.List;

import javax.ejb.Stateless;
import javax.ejb.TransactionManagement;
import javax.ejb.TransactionManagementType;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

import com.klef.ep.models.Dispatcher;

@Stateless
@TransactionManagement(TransactionManagementType.BEAN)
public class DispatcherServiceImpl implements DispatcherService
{

	@Override
	public Dispatcher dispatcherlogin(String username, String password) 
	{
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
	    EntityManager em = emf.createEntityManager();
	    
	    Query qry = em.createQuery("select d from Dispatcher d where d.username=? and d.password=?  ");
	    qry.setParameter(1, username);
	    qry.setParameter(2, password);
	    	
        Dispatcher dispatch = null;
        
        if(qry.getResultList().size()>0)
        {
           dispatch  = (Dispatcher) qry.getSingleResult();
        }
    em.close();
    emf.close();
    
    return dispatch;
	    
	}

	@Override
	public String updatedispatcher(Dispatcher dispatcher) {
	    EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
	    EntityManager em = emf.createEntityManager();
	    
	    em.getTransaction().begin();
	    
	    Dispatcher dis = em.find(Dispatcher.class, dispatcher.getEmail());
	    System.out.println(" DOnnnnee");
	    dis.setPassword(dispatcher.getPassword());
	    
	    em.getTransaction().commit();
	    em.close();
	    emf.close();
	    
	    return "Updated Successfully";
	    
	}


	@Override
	public String adddispatcher(Dispatcher dispatcher)
    {
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
		EntityManager em = emf.createEntityManager();
		
		em.getTransaction().begin();
		em.persist(dispatcher);
		em.getTransaction().commit();
		
		em.close();
		emf.close();

		return "Dispatcher Registered Successfully";
		
	}

	@Override
	public Dispatcher dispatcheremail(String email) {
	    EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
	    EntityManager em = emf.createEntityManager();
	    
	    Query qry = em.createQuery("select d from Dispatcher d where d.email = :email");
	    qry.setParameter("email", email);
	    
	    Dispatcher dispatch = null;
	    
	    if (!qry.getResultList().isEmpty()) {
	        dispatch = (Dispatcher) qry.getSingleResult();
	    }
	    em.close();
	    emf.close();
	    System.out.println(dispatch.getEmail());
	    return dispatch;
	}

	@Override
	public List<Dispatcher> viewalldis() {
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
		EntityManager em = emf.createEntityManager();
		
		Query qry = em.createQuery("select e from Dispatcher e");
		// e is an alias of Employee Class
		List<Dispatcher> dislist = qry.getResultList();
		
	    em.close();
	    emf.close();
	    
	    return dislist;
	}
	

	@Override
	public String deletedispatcher(String contact) {
		EntityManagerFactory emf = Persistence.createEntityManagerFactory("jpa");
		EntityManager em = emf.createEntityManager();
		
		em.getTransaction().begin();
		
		Dispatcher e = em.find(Dispatcher.class, contact);
		em.remove(e);
		em.getTransaction().commit();
		
		em.close();
		emf.close();
		
		return "Dispatcher Deleted Successfully";
	}

	
	

}
