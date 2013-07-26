package com.hopi.dao;

import java.util.Collection;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit38.AbstractTransactionalJUnit38SpringContextTests;

/**
 * @author 董依良
 * @since 2013-7-23
 */
@ContextConfiguration(locations = { "classpath:/context-config.xml",
		"classpath:/context-dao-local.xml" })
public class BaseDaoTest{ 
//extends AbstractTransactionalJUnit38SpringContextTests {
	@Autowired
	protected Dao dao;

	public void testQueryForPage() {
//		assertEquals("1", "1");
//		Collection<Vet> vets = this.clinic.getVets();
//		assertEquals("JDBC query must show the same number of vets", super
//				.countRowsInTable("VETS"), vets.size());
//		Vet v1 = EntityUtils.getById(vets, Vet.class, 2);
//		assertEquals("Leary", v1.getLastName());
//		assertEquals(1, v1.getNrOfSpecialties());
//		assertEquals("radiology", (v1.getSpecialties().get(0)).getName());
//		// ...
	}

}