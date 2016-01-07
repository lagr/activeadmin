Feature: Index Formats

  Scenario: View index with default formats
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should see a link to download "CSV"
    And I should see a link to download "XML"
    And I should see a link to download "JSON"

  Scenario: View index with download_links set to false
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :download_links => false
      end
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should not see a link to download "CSV"
    And I should not see a link to download "XML"
    And I should not see a link to download "JSON"

  Scenario: View index with pdf download link set
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :download_links => [:pdf]
      end
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should not see a link to download "CSV"
    And I should not see a link to download "XML"
    And I should not see a link to download "JSON"
    And I should see a link to download "PDF"

  Scenario: View index with download_links block which returns false
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :download_links => proc { false }
      end
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should not see a link to download "CSV"
    And I should not see a link to download "XML"
    And I should not see a link to download "JSON"

  Scenario: View index with download_links block which returns [:csv]
    Given an index configuration of:
    """
      ActiveAdmin.register Post do
        index :download_links => -> { [:csv] }
      end
    """
    And 1 post exists
    When I am on the index page for posts
    Then I should see a link to download "CSV"
    And I should not see a link to download "XML"
    And I should not see a link to download "JSON"
    And I should not see a link to download "PDF"

  Scenario: View index with an authorization adapter that forbids json
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 1 post exists
    And a configuration of:
    """
    class NoJSONAuthorization < ActiveAdmin::AuthorizationAdapter
      def authorized?(action, subject = nil, format = nil)
        case format
        when :json
          false
        else
          true
        end
      end
    end

    ActiveAdmin.application.authorization_adapter = OnlyAuthorsAuthorization
    """
    Then I should see a link to download "CSV"
    And I should see a link to download "XML"
    And I should not see a link to download "JSON"

  Scenario: View index with an authorization adapter that forbids all formats
    Given an index configuration of:
    """
      ActiveAdmin.register Post
    """
    And 1 post exists
    And a configuration of:
    """
    class NoJSONAuthorization < ActiveAdmin::AuthorizationAdapter
      def authorized?(action, subject = nil, format = nil)
        case format
        when :json, :xml, :csv
          false
        else
          true
        end
      end
    end

    ActiveAdmin.application.authorization_adapter = OnlyAuthorsAuthorization
    """
    Then I should not see a link to download "CSV"
    And I should not see a link to download "XML"
    And I should not see a link to download "JSON"
