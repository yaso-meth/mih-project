from sqlalchemy import DateTime, Column, Integer, String, DECIMAL, text
from sqlalchemy.orm import declarative_base
Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    __table_args__ = {'schema': 'app_data'}
    idusers = Column(Integer, primary_key=True) 
    email = Column(String(128), nullable=False, unique=True)
    fname = Column(String(128), nullable=False)
    lname = Column(String(128), nullable=False)
    type = Column(String(128), nullable=False)
    app_id = Column(String(128), nullable=False)
    username = Column(String(128), nullable=False)
    pro_pic_path = Column(String(128), nullable=False)
    purpose = Column(String(256), nullable=False, server_default="")

    def __repr__(self):
        return (
            f"<User(idusers={self.idusers}, email='{self.email}', "
            f"fname='{self.fname}', lname='{self.lname}', type='{self.type}', "
            f"app_id='{self.app_id}', username='{self.username}', "
            f"pro_pic_path='{self.pro_pic_path}', purpose='{self.purpose}')>"
        )

class Business(Base):
    __tablename__ = 'business'
    __table_args__ = {'schema': 'app_data'}
    idbusiness = Column(Integer, primary_key=True)
    business_id = Column(String(128), nullable=False, unique=True)
    Name = Column(String(128))  
    type = Column(String(128))
    registration_no = Column(String(128))
    logo_name = Column(String(128))
    logo_path = Column(String(128))
    contact_no = Column(String(45))
    bus_email = Column(String(128))
    gps_location = Column(String(128))
    practice_no = Column(String(45))
    vat_no = Column(String(45))
    website = Column(String(128))
    rating = Column(String(45), server_default="''") # Changed to match image default
    mission_vision = Column(String(256))

    def __repr__(self):
        return (
            f"<Business(idbusiness={self.idbusiness}, business_id='{self.business_id}', "
            f"Name='{self.Name}', type='{self.type}', "
            f"registration_no='{self.registration_no}', logo_name='{self.logo_name}', "
            f"logo_path='{self.logo_path}', contact_no='{self.contact_no}', "
            f"bus_email='{self.bus_email}', gps_location='{self.gps_location}', "
            f"practice_no='{self.practice_no}', vat_no='{self.vat_no}', "
            f"website='{self.website}', rating='{self.rating}', "
            f"mission_vision='{self.mission_vision}')>"
        )

class BusinessRating(Base):
    __tablename__ = 'business_ratings'
    __table_args__ = {'schema': 'mzansi_directory'}
    idbusiness_ratings = Column(Integer, primary_key=True)
    app_id = Column(String(128), nullable=False, server_default="")
    business_id = Column(String(128), nullable=False, server_default="")
    rating_title = Column(String(128), nullable=False, server_default="")
    rating_description = Column(String(256), nullable=False, server_default="")
    rating_score = Column(String(45), nullable=False, server_default="")
    date_time = Column(DateTime, nullable=True)
    def __repr__(self):
        return (
            f"<BusinessRating(idbusiness_ratings={self.idbusiness_ratings}, app_id='{self.app_id}', "
            f"business_id='{self.business_id}', rating_title='{self.rating_title}', rating_description='{self.rating_description}', "
            f"rating_score='{self.rating_score}', date_time='{self.date_time}')>"
        )
class BookmarkedBusiness(Base):
    __tablename__ = 'bookmarked_businesses'
    __table_args__ = {'schema': 'mzansi_directory'}
    idbookmarked_businesses = Column(Integer, primary_key=True)
    app_id = Column(String(128), nullable=False, server_default="")
    business_id = Column(String(128), nullable=False, server_default="")
    created_date = Column(DateTime, nullable=True)
    def __repr__(self):
        return (
            f"<BusinessRating(idbookmarked_businesses={self.idbookmarked_businesses}, app_id='{self.app_id}', "
            f"business_id='{self.business_id}', created_date='{self.created_date}')>"
        )


class UserConsent(Base):
    __tablename__ = 'user_consent'
    __table_args__ = {'schema': 'app_data'}
    iduser_consent = Column(Integer, primary_key=True) 
    app_id = Column(String(128), nullable=False,server_default=text("''"))
    privacy_policy_accepted = Column(DateTime, nullable=True)
    terms_of_services_accepted = Column(DateTime, nullable=True)

    def __repr__(self):
        return (
            f"<UserConsent(iduser_consent={self.iduser_consent}, "
            f"app_id='{self.app_id}', "
            f"privacy_policy_accepted='{self.privacy_policy_accepted}', "
            f"terms_of_services_accepted='{self.terms_of_services_accepted}')>"
        )

class MineSweeperLeaderboard(Base):
    __tablename__ = 'player_score' 
    __table_args__ = {'schema': 'minesweeper_leaderboard'}
    idplayer_score = Column(Integer, primary_key=True) 
    app_id = Column(String(128), nullable=False,server_default=text("''"))
    difficulty = Column(String(45), nullable=False,server_default=text("''"))
    game_time = Column(String(45), nullable=False,server_default=text("''"))
    game_score = Column(DECIMAL(45), nullable=False)
    played_date = Column(DateTime, nullable=True)

    def __repr__(self):
        return (
            f"<MineSweeperLeaderboard(idplayer_score={self.idplayer_score}, "
            f"app_id='{self.app_id}', "
            f"difficulty='{self.difficulty}', "
            f"game_time='{self.game_time}', "
            f"game_score='{self.game_score}' "
            f"played_date='{self.played_date}')>"
        )