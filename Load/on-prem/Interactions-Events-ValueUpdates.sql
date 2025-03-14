
UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'EventType_ChangeProfileScoresEvent'
WHERE EventType = 'ChangeProfileScoresEvent'

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'MVTestTriggered'
WHERE EventType = '#Sitecore.ContentTesting.Model.xConnect.MVTestTriggered' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'PersonalizationEvent'
WHERE EventType = '#Sitecore.ContentTesting.Model.xConnect.PersonalizationEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'Goal'
WHERE EventType = '#Sitecore.XConnect.Goal' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'Event'
WHERE EventType = '#Sitecore.XConnect.Event' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'Outcome'
WHERE EventType = '#Sitecore.XConnect.Outcome' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'DownloadEvent'
WHERE EventType = '#Sitecore.XConnect.Collection.Model.DownloadEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'CampaignEvent'
WHERE EventType = '#Sitecore.XConnect.Collection.Model.CampaignEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'ChangeProfileScoresEvent'
WHERE EventType = '#Sitecore.XConnect.Collection.Model.ChangeProfileScoresEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'PageViewEvent'
WHERE EventType = '#Sitecore.XConnect.Collection.Model.PageViewEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'SearchEvent'
WHERE EventType = '#Sitecore.XConnect.Collection.Model.SearchEvent' 

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'GenericEvent'
WHERE EventType IS NULL AND Data IS NULL

GO--

UPDATE ${warehouse}.[dbo].[I_Events]
SET EventType = 'Error'
WHERE EventType IS NULL

GO--