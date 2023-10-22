# https://github.com/badeball/cypress-cucumber-preprocessor/issues/922

Feature: visualizing hook with filter
  Scenario: visualizing hook with filter
    Given a file named "cypress/e2e/a.feature" with:
      """
      @foo
      Feature: a feature
        Scenario: a scenario
          Given a step
      """
    And a file named "cypress/support/step_definitions/steps.js" with:
      """
      const { Before, Given } = require("@badeball/cypress-cucumber-preprocessor");
      Before(() => {})
      Before({ tags: "@foo or @bar" }, () => {})
      Given("a step", function() {
        cy.then(() => {}).should(() => {
          expect(
            Cypress.$(top.document).find(
              ".command-info:has(> .command-method:contains('Before')) .command-message-text:contains('@foo or @bar')"
            )
          ).to.exist;
        });
      })
      """
    When I run cypress
    Then it passes
