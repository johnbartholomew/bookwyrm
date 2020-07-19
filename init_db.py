''' starter data '''
from fedireads.models import Connector, User
from fedireads.settings import DOMAIN

User.objects.create_user('jpab', 'jpa.bartholomew@gmail.com', 'booksarefun')

Connector.objects.create(
    identifier='openlibrary.org',
    name='OpenLibrary',
    connector_file='openlibrary',
    base_url='https://openlibrary.org',
    books_url='https://openlibrary.org',
    covers_url='https://covers.openlibrary.org',
    search_url='https://openlibrary.org/search?q=',
)

Connector.objects.create(
    identifier=DOMAIN,
    name='Local',
    local=True,
    connector_file='self_connector',
    base_url='https://%s' % DOMAIN,
    books_url='https://%s/book' % DOMAIN,
    covers_url='https://%s/images/covers' % DOMAIN,
    search_url='https://%s/search?q=' % DOMAIN,
    priority=1,
)
