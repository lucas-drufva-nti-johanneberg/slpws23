describe('Login as Admin', () => {
  it('passes', () => {
    cy.visit('http://localhost:4567')

    // Get an input, type into it
    cy.get('#phone').type('10')

    //  Verify that the value has been updated
    cy.get('#phone').should('have.value', '10')

    cy.get('.register-btn').click()

    cy.url().should('include', '/admin')

  })
})

describe('Login as Parent', () => {
  it('passes', () => {
    cy.visit('http://localhost:4567')

    // Get an input, type into it
    cy.get('#phone').type('5')

    //  Verify that the value has been updated
    cy.get('#phone').should('have.value', '5')

    cy.get('.register-btn').click()

    cy.url().should('include', '/driver')

  })
})
