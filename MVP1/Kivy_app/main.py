from Include import *
from AddActivity import AddActivityScreen
from Calendar import CalendarScreen
from Settings import SetupScreen
from Users import User

# Crear o conectar a una base de datos SQLite
conn = sqlite3.connect('example.db')
c = conn.cursor()

# Crear una tabla
c.execute('''DROP TABLE IF EXISTS users''')
c.execute('''CREATE TABLE IF NOT EXISTS users
             (id INTEGER PRIMARY KEY, name TEXT, password TEXT, email TEXT)''')

c.execute('''CREATE TABLE IF NOT EXISTS activities
             (id INTEGER PRIMARY KEY, user_id INTEGER REFERENCES users(id), name TEXT, description TEXT, date TEXT, time TEXT)''')

# Insertar un registro
c.execute("INSERT INTO activities (user_id, name, description, date, time) VALUES (?, ?, ?, ?, ?)", (1, 'Activity 1', 'Description 1', '2021-10-01', '10:00'))

c.execute("INSERT INTO users (name, password, email) VALUES (?, ?, ?)", ('Alice', '1234', 'alice@example.com'))
c.execute("INSERT INTO users (name, password, email) VALUES (?, ?, ?)", ('Bob', '5678', 'bob@example.com'))
conn.commit()



class MainScreen(Screen):
    def __init__(self, sm,user, **kwargs):
        super(MainScreen, self).__init__(**kwargs)
        layout = FloatLayout()
        self.sm = sm
        self.user = user
        layout.add_widget(Label(text='Main Screen', size_hint=(.2, .1), pos_hint={'x':.0, 'y':.9}))
        layout.add_widget(Label(text=f"{self.user.name}'s Board ", size_hint=(.2, .1), pos_hint={'x':.4, 'y':.9},color=(0,0,1,1)))

        btn = Button(text='Go to Login Screen', size_hint=(.16, .05), pos_hint={'x':.8, 'y':.93})
        btn.bind(on_press=self.change_screen)
        layout.add_widget(btn)

        btn = Button(text="Calendar", size_hint=(.8, .1), pos_hint={'x':.1, 'y':.6})
        btn.bind(on_press=self.calendar)
        layout.add_widget(btn)

        btn = Button(text="User Settings", size_hint=(.8, .1), pos_hint={'x':.1, 'y':.4})
        btn.bind(on_press=self.change_setup)
        layout.add_widget(btn)

        btn = Button(text="Add Activity", size_hint=(.8, .1), pos_hint={'x':.1, 'y':.2})
        btn.bind(on_press=self.add_activity)
        layout.add_widget(btn)

        self.add_widget(layout)

    def change_screen(self, instance): 
        self.sm.clear_widgets()
        MyApp().run()

    def calendar(self, instance):
        self.sm.add_widget(CalendarScreen(name='calendar'))
        App.get_running_app().root.current = 'calendar'
    
    def change_setup(self, instance):
        self.sm.add_widget(SetupScreen(name='setup',us=self.user,sm=self.sm))
        App.get_running_app().root.current = 'setup'
    
    def add_activity(self, instance):
        self.sm.add_widget(AddActivityScreen(name='add_activity'))
        App.get_running_app().root.current = 'add_activity'
    

class AfterLoginScreen(Screen):
    def __init__(self,user,sm, **kwargs ):
        super(AfterLoginScreen, self).__init__(**kwargs)
        layout = BoxLayout(orientation='vertical')
        self.user = user
        self.sm = sm
        layout.add_widget(Label(text=f'Welcome {self.user.name}'))
        Clock.schedule_once(self.change_screen, 2)

        self.add_widget(layout)
    def change_screen(self,dt):
        self.sm.add_widget(MainScreen(name='main',user=self.user,sm=self.sm))
        App.get_running_app().root.current = 'main'

class CreateAccountScreen(Screen):
    def __init__(self,sm, **kwargs):
        super(CreateAccountScreen, self).__init__(**kwargs)
        self.sm = sm
        layout = BoxLayout(orientation='vertical')

        layout.add_widget(Label(text='Create Account'))

        layout.add_widget(Label(text='Name:'))
        self.name_input = TextInput(multiline=False)
        layout.add_widget(self.name_input)

        layout.add_widget(Label(text='Password:'))
        self.password = TextInput(password=True, multiline=False)
        layout.add_widget(self.password)

        layout.add_widget(Label(text='Email:'))
        self.email = TextInput(multiline=False)
        layout.add_widget(self.email)

        layouth = BoxLayout(orientation='horizontal')
        btn = Button(text='Create Account', on_press=self.create_account)
        layouth.add_widget(btn)

        btn = Button(text='Back', on_press=self.back)
        layouth.add_widget(btn)
        layout.add_widget(layouth)
        self.add_widget(layout)
    
    def create_account(self, instance):
        c.execute("SELECT * FROM users WHERE name=?", (self.name_input.text,))
        result = c.fetchone()

        if result is not None:
            print(f"Usuario {self.name_input.text} encontrado en la base de datos.")
        else:
            c.execute("INSERT INTO users (name, password, email) VALUES (?, ?, ?)", (self.name_input.text, self.password.text, self.email.text))
            conn.commit()
            print(f"Usuario {self.name_input.text} creado en la base de datos.")

            App.get_running_app().root.current = 'login'
    
    def back(self, instance):
        App.get_running_app().root.current = 'login'

class LoginScreen(Screen):
    def __init__(self,sm, **kwargs):
        super(LoginScreen, self).__init__(**kwargs)
        self.sm = sm
        
        layout = BoxLayout(orientation='vertical')

        layout.add_widget(Label(text='Username:'))

        self.username = TextInput(multiline=False)
        layout.add_widget(self.username)

        layout.add_widget(Label(text='Password:'))

        self.password = TextInput(password=True, multiline=False)
        layout.add_widget(self.password)

        layouth = BoxLayout(orientation='horizontal')
        self.create_account = Button(text='Create Account', on_press=self.create_accountt)
        layouth.add_widget(self.create_account)
        self.submit = Button(text='Submit', on_press=self.verify_credentials)
        layouth.add_widget(self.submit)

        layout.add_widget(layouth)

        self.add_widget(layout)
        
        

    def verify_credentials(self, instance):
        # Consultar la base de datos
        c.execute("SELECT * FROM users WHERE name=?", (self.username.text,))
        result = c.fetchone()

        # Si el resultado no es None, entonces el usuario existe
        if result is not None:
            print(f"Usuario {self.username.text} encontrado en la base de datos.")
            # Cambiar a la pantalla AfterLoginScreen
            print(result[0],result[1],result[2],result[3])
            us = User(result[0],result[1],result[2],result[3])
            self.sm.add_widget(AfterLoginScreen(name='after_login',sm = self.sm, user=us))
            App.get_running_app().root.current = 'after_login'
        else:
            print(f"Usuario {self.username.text} no encontrado en la base de datos.")
    
    def create_accountt(self, instance):
        # Consultar la base de datos
        c.execute("SELECT * FROM users WHERE name=?", (self.username.text,))
        result = c.fetchone()

        # Si el resultado no es None, entonces el usuario existe
        if result is not None:
            print(f"Usuario {self.username.text} encontrado en la base de datos.")
        else:
            self.sm.add_widget(CreateAccountScreen(name='create_account',sm = self.sm, user = User()))
            App.get_running_app().root.current = 'create_account'

class MyApp(App):
    def __init__(self, **kwargs):
        super(MyApp, self).__init__(**kwargs)
        self.title = "My App"
        
    def build(self):
        sm = ScreenManager()
        sm.add_widget(LoginScreen(name='login',sm=sm))
        #sm.add_widget(AfterLoginScreen(name='after_login',user=x))
        #sm.add_widget(MainScreen(name='main'))
        return sm
        

if __name__ == '__main__':
    MyApp().run()

# Cerrar la conexión cuando se cierra la aplicación
conn.close()
