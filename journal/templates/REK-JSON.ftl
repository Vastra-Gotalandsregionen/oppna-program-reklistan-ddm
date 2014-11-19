


<style>
	.heading {
		color: #0000CC;
		text-transform: uppercase;
		font-weight: bold;
	}

	.subheading {
		color: #0000CC;
		font-weight: bold;	
	}

	.subheading-2 {
		color: #0000CC;
	}

	.area {
		font-weight: bold;
	}

	.substance {

	}

	.drug {
		padding-left: 10px;
	}

	.infobox {
		width: 200px;
		background-color: #eee;
		border-left: 5px solid #00C;
		padding: 10px;
		margin-top: 10px;
	}

	/* paddings */
	.area,
	.subheading-2 {
		padding-top: 15px;
	}

	.area.item-0,
	.subheading-2.item-0 {
		padding-top: 0;
	}

	.heading {
		padding-top: 45px;
	}

	.heading.item-0 {
		padding-top: 0;
	}	

</style>


<#list rec_drugs.rec_drugs__heading.getSiblings() as sib_rec_drugs__heading>

		<#if (sib_rec_drugs__heading.getData()!?length > 0)>
			<div class="heading item-${sib_rec_drugs__heading_index}">${sib_rec_drugs__heading.getData()}</div>
		</#if>


		<#list sib_rec_drugs__heading.rec_drugs__heading__subheading__subheading.getSiblings() as sib_rec_drugs__heading__subheading__subheading>

				<#if (sib_rec_drugs__heading__subheading__subheading.getData()!?length > 0)>
					<div class="subheading item-${sib_rec_drugs__heading__subheading__subheading_index}">${sib_rec_drugs__heading__subheading__subheading.getData()}</div>
				</#if>


				<#list sib_rec_drugs__heading__subheading__subheading.Underrubrik_2__Blå_normal_.getSiblings() as sib_Underrubrik_2__Blå_normal_>

						<#if (sib_Underrubrik_2__Blå_normal_.getData()!?length > 0)>
							<div class="subheading-2 item-${sib_Underrubrik_2__Blå_normal__index}">${sib_Underrubrik_2__Blå_normal_.getData()}</div>
						</#if>


						<#list sib_Underrubrik_2__Blå_normal_.rec_drugs__heading__subheading.getSiblings() as sib_rec_drugs__heading__subheading>

								<#if (sib_rec_drugs__heading__subheading.getData()!?length > 0)>
									<div class="area item-${sib_rec_drugs__heading__subheading_index}">${sib_rec_drugs__heading__subheading.getData()}</div>
								</#if>


								<#list sib_rec_drugs__heading__subheading.rec_drugs__heading__subheading__substance.getSiblings() as sib_rec_drugs__heading__subheading__substance>


										<#if (sib_rec_drugs__heading__subheading__substance.getData()!?length > 0)>
											<div class="substance item-${sib_rec_drugs__heading__subheading__substance_index}">
												${sib_rec_drugs__heading__subheading__substance.getData()}
												<#-- Checking if replaceable -->
												<#if sib_rec_drugs__heading__subheading__substance.rec_drugs__heading__subheading__replaceable.getData() == 'true'>
													(ERSÄTTNINGSBART)
												</#if>
											</div>
										</#if>
										


										<#list sib_rec_drugs__heading__subheading__substance.rec_drugs__heading__subheading__substance__drug.getSiblings() as sib_rec_drugs__heading__subheading__substance__drug>
												<#if (sib_rec_drugs__heading__subheading__substance__drug.getData()!?length > 0)>
													<div class="drug item-${sib_rec_drugs__heading__subheading__substance__drug_index}">${sib_rec_drugs__heading__subheading__substance__drug.getData()}</div>
												</#if>
										</#list>



								</#list>



						</#list>



				</#list>



		</#list>

		<#if (sib_rec_drugs__heading.rec_drugs__infobox.getData()!?length > 0)>
			<div class="infobox">${sib_rec_drugs__heading.rec_drugs__infobox.getData()}</div>
		</#if>

</#list>



